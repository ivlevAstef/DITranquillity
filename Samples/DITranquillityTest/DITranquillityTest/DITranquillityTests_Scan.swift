//
//  DITranquillityTests_Scan.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 14/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

import SubProject1
import SubProject2


public class ScannedRecursiveBase: DIScanned {}

public class RecursivePart1Type { }
public class ScannedRecursivePart_1: ScannedRecursiveBase, DIPart {
	public static func load(container: DIContainer) {
    container.register(RecursivePart1Type.init)
	}
}

public class RecursivePart2Type { }
public class ScannedRecursivePart_2: ScannedRecursiveBase, DIPart {
	public static func load(container: DIContainer) {
		container.register(RecursivePart2Type.init)
	}
}

private class ScanFramework: DIScanFramework {
  override class var predicate: Predicate? { return .name({ $0.contains("Framework") }) }
}

class FrameworkWithScan1: DIFramework {
  private class ScanFramework: DIScanFramework {
    override class var predicate: Predicate? { return .name({ $0.contains("Framework") }) }
  }
  
  public static func load(container: DIContainer) {
    container.append(framework: ScanFramework.self)
  }
}

class FrameworkWithScan2: DIFramework {
  private class ScanPart: DIScanPart {
    override class var predicate: Predicate? { return .name({ $0.contains("Part") }) }
  }
  
  public static func load(container: DIContainer) {
    container.append(part: ScanPart.self)
  }
}

class FrameworkWithScan3: DIFramework {
  private class ScanPrt: DIScanPart {
    override class var predicate: Predicate? { return .name({ $0.contains("Prt") }) }
  }
  
  public static func load(container: DIContainer) {
    container.append(part: ScanPrt.self)
  }
}

// Tests

class DITranquillityTests_Scan: XCTestCase {
  
  func test01_ScanParts() {
    class ScanPart: DIScanPart {
      override class var predicate: Predicate? { return .name({ $0.contains("Part") }) }
    }
    
    let container = DIContainer()
    container.append(part: ScanPart.self)
    
    let type1: Module1Type? = *container
    let type2: Module2Type? = *container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
  }

  func test02_ScanPrts() {
    class ScanPrt: DIScanPart {
      override class var predicate: Predicate? { return .name({ $0.contains("Prt") }) }
    }
    
    let container = DIContainer()
    container.append(part: ScanPrt.self)
    
    let type1: DuMole1Type? = *container
    let type2: DuMole2Type? = *container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
  }

  func test03_ScanFramework() {
    class ScanFramework: DIScanFramework {
      override class var predicate: Predicate? { return .name({ $0.contains("ScannedFramework") }) }
    }

    let container = DIContainer()
    container.append(framework: ScanFramework.self)
		
    let type1: Module1Type? = *container
    let type2: Module2Type? = *container
    
    let type3: DuMole1Type? = *container
    let type4: DuMole2Type? = *container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
    XCTAssertNotNil(type3)
    XCTAssertNotNil(type4)
  }
  
  func test04_ScanFrameworkUseFramework1() {
    let container = DIContainer()
    container.append(framework: FrameworkWithScan1.self)
		
    let type1: Module1Type? = *container
    let type2: Module2Type? = *container
    
    let type3: DuMole1Type? = *container
    let type4: DuMole2Type? = *container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
    XCTAssertNotNil(type3)
    XCTAssertNotNil(type4)
  }

  func test05_ScanFrameworkUseFramework2() {
    let container = DIContainer()
    container.append(framework: FrameworkWithScan2.self)
		
    let type1: Module1Type? = *container
    let type2: Module2Type? = *container
    
    let type3: DuMole1Type? = *container
    let type4: DuMole2Type? = *container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
    XCTAssertNil(type3)
    XCTAssertNil(type4)
  }

  func test06_ScanFrameworkUseFramework3() {
    let container = DIContainer()
    container.append(framework: FrameworkWithScan3.self)
		
    let type1: Module1Type? = *container
    let type2: Module2Type? = *container
    
    let type3: DuMole1Type? = *container
    let type4: DuMole2Type? = *container
    
    XCTAssertNil(type1)
    XCTAssertNil(type2)
    XCTAssertNotNil(type3)
    XCTAssertNotNil(type4)
  }

	func test07_ScanFrameworksInBundleSubProject1() {
    class ScanPart: DIScanPart {
      override class var bundle: Bundle? { return Bundle(for: ScannedFramework1.self) }
    }
		let container = DIContainer()
		container.append(part: ScanPart.self)
		
		let type1: Module1Type? = *container
		let type2: Module2Type? = *container
		
		let type3: DuMole1Type? = *container
		let type4: DuMole2Type? = *container
		
		XCTAssertNotNil(type1)
		XCTAssertNotNil(type2)
		XCTAssertNil(type3)
		XCTAssertNil(type4)
	}

	func test07_ScanFrameworksInBundleSubProject2() {
    class ScanPart: DIScanPart {
      override class var bundle: Bundle? { return Bundle(for: ScannedFramework2.self) }
    }
		let container = DIContainer()
    container.append(part: ScanPart.self)
		
		let type1: Module1Type? = *container
		let type2: Module2Type? = *container
		
		let type3: DuMole1Type? = *container
		let type4: DuMole2Type? = *container
		
		XCTAssertNil(type1)
		XCTAssertNil(type2)
		XCTAssertNotNil(type3)
		XCTAssertNotNil(type4)
	}

	func test08_ScanFrameworksPredicateByType() {
    class ScanPart: DIScanPart {
      override class var predicate: Predicate? { return .type({ $0 is ScannedRecursiveBase.Type }) }
    }
    
		let container = DIContainer()
    container.append(part: ScanPart.self)
		
		let type1: RecursivePart1Type? = *container
		let type2: RecursivePart2Type? = *container

		XCTAssertNotNil(type1)
		XCTAssertNotNil(type2)
	}
	
}
