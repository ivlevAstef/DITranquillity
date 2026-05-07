//
//  DITranquillityTests_ResolveByInit.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 31/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

@globalActor
private actor MyGlobalActor {
    static let shared = MyGlobalActor()
}

@MainActor
private final class TestOtherMainActor {
    let str: String = "foo"
    init(injected: TestActorClassInjected) {
        MainActor.assertIsolated()
    }
}

@MainActor
private final class TestMainActor {
    let str: String = "bar"
    let other: TestOtherMainActor
    init(other: TestOtherMainActor) {
        self.other = other
        MainActor.assertIsolated()
    }
}

@MainActor
private final class TestMainActorArgument {
    let str: String = "bar"
    let arg: Int
    let other: TestOtherMainActor
    init(arg: Int, other: TestOtherMainActor) {
        self.arg = arg
        self.other = other
        assert(Thread.isMainThread)
        MainActor.assertIsolated()
    }
}

@MainActor
private final class TestMainActorArgument2 {
    let str: String = "bar"
    let arg1: Int
    let arg2: String
    let other: TestOtherMainActor
    init(arg1: Int, arg2: String, other: TestOtherMainActor) {
        self.arg1 = arg1
        self.arg2 = arg2
        self.other = other
        assert(Thread.isMainThread)
        MainActor.assertIsolated()
    }
}

@MyGlobalActor
private final class TestGlobalActor: Sendable {
    let str: String = "global"
    init() {
//        MyGlobalActor.assertIsolated()
    }
}

private final class TestActorClassInjected: Sendable {
    let str: String = "inj"
}

private actor TestActorActorInjected {
}

private actor TestActor {
    let str: String = "bar"
    let otherClass: TestActorClassInjected
    let otherActor: TestActorActorInjected

    private(set) var isRunning: Bool = false

    private(set) var methodMainActor: TestMainActor?

    init(otherClass: TestActorClassInjected, otherActor: TestActorActorInjected) async {
        self.otherClass = otherClass
        self.otherActor = otherActor
    }

    func inject(mainActor: TestMainActor) {
        self.methodMainActor = mainActor
    }

    func run() {
        isRunning = true
    }
}

class DITranquillityTests_ResolveAsyncAndSync: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    func test05_ResolveMainActor() async {
        let expectationMainActor = XCTestExpectation(description: "test05_task_main_actor")
        let expectationGlobalActor = XCTestExpectation(description: "test05_task_global_actor")
        let expectationQueue = XCTestExpectation(description: "test05_task_queue")
        
        let container = DIContainer()
        
        container.register(TestOtherMainActor.init)
        container.register(TestMainActor.init)
        container.register(TestMainActorArgument.init) { arg($0) }
        container.register(TestMainActorArgument2.init) { (arg($0), arg($1)) }
        container.register(TestActorClassInjected.init)
        container.register(TestGlobalActor.init)
        
        let m1: TestOtherMainActor = await container.resolve()
        let m2: TestMainActor = await container.resolve()
        let m3: TestMainActorArgument = await container.resolve(args: 10)
        let m4: TestMainActorArgument2 = await container.resolve(args: 100, "a100")
        let m5: TestGlobalActor = await container.resolve()
        let m6: Provider<TestGlobalActor> = await container.resolve()
        let m6a: AsyncProvider<TestGlobalActor> = await container.resolve()
        let m6s: Provider<TestGlobalActor> = container.resolve(sync:())
        let m6sa: AsyncProvider<TestGlobalActor> = container.resolve(sync:())

        XCTAssert(m1.str == "foo")
        XCTAssert(m2.str == "bar")
        XCTAssert(m3.arg == 10)
        XCTAssert(m4.arg1 == 100 && m4.arg2 == "a100")
        XCTAssert(m5.str == "global")
        XCTAssert(m6.value.str == "global")
        let m6astr = await m6a.value.str
        XCTAssert(m6astr == "global")

        XCTAssert(m6s.value.str == "global")
        let m6sastr = await m6sa.value.str
        XCTAssert(m6sastr == "global")

        Task { @MainActor in
            let m1: TestOtherMainActor = await container.resolve()
            let m2: TestMainActor = await container.resolve()
            let m3: TestMainActorArgument = await container.resolve(args: 30)
            let m4: TestMainActorArgument2 = await container.resolve(args: 300, "a300")
            
            XCTAssert(m1.str == "foo")
            XCTAssert(m2.str == "bar")
            XCTAssert(m3.arg == 30)
            XCTAssert(m4.arg1 == 300 && m4.arg2 == "a300")
            
            expectationMainActor.fulfill()
        }
        
        Task { @MyGlobalActor in
            let m1: TestOtherMainActor = await container.resolve()
            let m2: TestMainActor = await container.resolve()
            let m3: TestMainActorArgument = await container.resolve(args: 40)
            let m4: TestMainActorArgument2 = await container.resolve(args: 400, "a400")
            let m5: TestGlobalActor = await container.resolve()
            
            XCTAssert(m1.str == "foo")
            XCTAssert(m2.str == "bar")
            XCTAssert(m3.arg == 40)
            XCTAssert(m4.arg1 == 400 && m4.arg2 == "a400")
            XCTAssert(m5.str == "global")
            
            expectationGlobalActor.fulfill()
        }
        
        Task.detached {
            let m1: TestOtherMainActor = await container.resolve()
            let m2: TestMainActor = await container.resolve()
            let m3: TestMainActorArgument = await container.resolve(args: 20)
            let m4: TestMainActorArgument2 = await container.resolve(args: 200, "a200")
            let m5: TestGlobalActor = await container.resolve()
            
            XCTAssert(m1.str == "foo")
            XCTAssert(m2.str == "bar")
            XCTAssert(m3.arg == 20)
            XCTAssert(m4.arg1 == 200 && m4.arg2 == "a200")
            XCTAssert(m5.str == "global")
            
            expectationQueue.fulfill()
        }
        
        await fulfillment(of: [expectationMainActor, expectationGlobalActor, expectationQueue], timeout: 5.0)
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    func test05_ResolveMainActorSync() {
        let expectations = [
            XCTestExpectation(description: "test05_task_main_thread"),
            XCTestExpectation(description: "test05_task_global_thread"),
            XCTestExpectation(description: "test05_task_main_actor"),
            XCTestExpectation(description: "test05_task_global_actor"),
            XCTestExpectation(description: "test05_task_queue")
        ]
        
        let container = DIContainer()
        
        container.register(TestOtherMainActor.init)
        container.register(TestMainActor.init)
        container.register(TestActorClassInjected.init)
        container.register(TestGlobalActor.init)
        
        let m1: TestOtherMainActor = container.resolve()
        let m2: TestMainActor = container.resolve()
        
        XCTAssert(m1.str == "foo")
        XCTAssert(m2.str == "bar")

        DispatchQueue.main.async {
            let m1: TestOtherMainActor = container.resolve()
            let m2: TestMainActor = container.resolve()
            XCTAssert(m1.str == "foo")
            XCTAssert(m2.str == "bar")
            
            expectations[0].fulfill()
        }

        DispatchQueue.global().async {
            let m1: TestOtherMainActor = container.resolve()
            let m2: TestMainActor = container.resolve()
            XCTAssert(m1.str == "foo")
            XCTAssert(m2.str == "bar")

            expectations[1].fulfill()
        }

        Task { @MainActor in
            let m1: TestOtherMainActor = await container.resolve()
            let m2: TestMainActor = await container.resolve()
            let m1s: TestOtherMainActor = container.resolve(sync:())
            let m2s: TestMainActor = container.resolve(sync:())
            let m5: TestGlobalActor = await container.resolve()
            let m5s: TestGlobalActor = container.resolve(sync:())

            XCTAssert(m1.str == "foo")
            XCTAssert(m2.str == "bar")
            XCTAssert(m1s.str == "foo")
            XCTAssert(m2s.str == "bar")
            XCTAssert(m5.str == "global")
            XCTAssert(m5s.str == "global")

            expectations[2].fulfill()
        }
        
        Task { @MyGlobalActor in
            let m1: TestOtherMainActor = await container.resolve()
            let m2: TestMainActor = await container.resolve()
            let m1s: TestOtherMainActor = container.resolve(sync:())
            let m2s: TestMainActor = container.resolve(sync:())
            let m5: TestGlobalActor = await container.resolve()
            let m5s: TestGlobalActor = container.resolve(sync:())
            let m6: Provider<TestGlobalActor> = await container.resolve()
            let m6as: AsyncProvider<TestGlobalActor> = await container.resolve()
            let m6a: AsyncProvider<TestGlobalActor> = container.resolve(sync: ())

            XCTAssert(m1.str == "foo")
            XCTAssert(m1s.str == "foo")
            XCTAssert(m2.str == "bar")
            XCTAssert(m2s.str == "bar")
            XCTAssert(m5.str == "global")
            XCTAssert(m5s.str == "global")
            XCTAssert(m6.value.str == "global")

            let value6as = await m6as.value
            XCTAssert(value6as.str == "global")
            let value6a = await m6a.value
            XCTAssert(value6a.str == "global")

            expectations[3].fulfill()
        }
        
        Task.detached {
            let m1: TestOtherMainActor = await container.resolve()
            let m2: TestMainActor = await container.resolve()
            let m5: TestGlobalActor = await container.resolve()
            let m6: Provider<TestGlobalActor> = await container.resolve()
            let m6as: AsyncProvider<TestGlobalActor> = await container.resolve()
            let m6a: AsyncProvider<TestGlobalActor> = container.resolve(sync: ())

            XCTAssert(m1.str == "foo")
            XCTAssert(m2.str == "bar")
            XCTAssert(m5.str == "global")
            XCTAssert(m6.value.str == "global")

            let value6as = await m6as.value
            XCTAssert(value6as.str == "global")
            let value6a = await m6a.value
            XCTAssert(value6a.str == "global")

            expectations[4].fulfill()
        }
        
        wait(for: expectations, timeout: 5.0)
    }

    func test06_ResolveActor() async {
        let container = DIContainer()

        container.register(TestActorClassInjected.init)
        container.register(TestActorActorInjected.init)
        container.register { await TestActor(otherClass: $0, otherActor: $1) }
            .injection { await $0.inject(mainActor: $1) }
            .postInit { await $0.run() }

        let m2: TestActor = await container.resolve()

        XCTAssert(m2.str == "bar")

        let isRunning = await m2.isRunning
        XCTAssert(isRunning)
    }
}
