# Migrating from version 5.x.x to 6.x.x

The main change in 6.0.0 is Swift Concurrency support: `async/await`, `@MainActor`, `actor` classes, and any `@globalActor` isolation. Architecturally, the code is rewritten for Swift 6 (`.swiftLanguageMode(.v6)`), and the external `SwiftLazy` dependency is now bundled into the library itself.

**Good news for most projects: migration requires almost no code changes.** Old synchronous registrations, `Lazy`, `Provider`, graph validation, `DIFramework`/`DIPart`, modificators (`arg`, `many`, `by(tag:on:)`) keep working as before. If you still support iOS 13–16, all you'll typically need is to switch `@MainActor` class registrations to the new `register(main:)` overload. The full asynchronous API (`register { await ... }`, `.injection { await ... }`) is recommended only on iOS 17+.

## ⚠️ Three warnings before migrating

### 1. The full async/await API requires iOS 17+

The synchronous API and registration of `@MainActor` classes via `register(main:)` work correctly on every supported platform (iOS 13+, macOS 10.15+, tvOS 13+, watchOS 8+).

However, the following capabilities are **only guaranteed on iOS 17+ / macOS 14+ / tvOS 17+ / watchOS 10+**:

- `container.register { await MyClass(dep: $0) }` — asynchronous registration.
- `.injection { await $0.setup($1) }`, `.postInit { await $0.start() }` — asynchronous injections.
- Registering classes with arbitrary actor isolation (`@globalActor` closures) that don't reduce to `@MainActor`. On older versions these `register(_:)` overloads are gated by `@available(iOS 17.0, *)` — the compiler simply won't expose them.

On iOS 13–16, simple async-registration scenarios formally work, but with complex context switches (multiple `actor`/isolation hops in a single object's creation chain) correctness is not guaranteed — the implementation uses a limited fallback. If your graph contains many async initializers or classes with different `@globalActor`s, raise the deployment target to iOS 17.

### 2. DelayMaker (Lazy / Provider) in complex scenarios

The internal lazy-resolution mechanism (`DelayMaker`) for `Lazy` and `Provider` has been rewritten in 6.0.0 and now has two execution paths — synchronous and asynchronous. In simple scenarios behavior matches 5.x.x, but in complex graphs (cycles, long `Provider<Lazy<T>>` chains, `Many<Lazy<T>>` combinations) behavior **may differ**. It's hard to be definitive — there are no stress tests for this yet.

If your dependency graph is large and uses Lazy/Provider in cycles, after migration definitely run `container.makeGraph().checkIsValid()` and your scenario tests, especially the ones that depend on exact initialization order.

### 3. Thread-safety is now always on

In 5.x.x you could disable thread-safety for a micro-optimization:
```swift
DISetting.Defaults.multiThread = false  // 5.x.x
```

In 6.0.0 the `DISetting.Defaults.multiThread` setting is **fully removed**. The container is always thread-safe — that's a requirement of the architecture now that Swift Concurrency is supported. If you were intentionally disabling the flag, just delete that line. The performance impact is minimal.

---

## What hasn't changed

The vast majority of the API stays where it was. Old synchronous code keeps compiling without edits:

- `container.register(MyType.init)`, `container.register { MyType(dep: $0) }` — works on all iOS versions.
- `.as(SomeProtocol.self)`, `.as(SomeProtocol.self, tag: SomeTag.self)`, `.as(SomeProtocol.self, name: "n")`.
- `.lifetime(.single)`, `.lifetime(.objectGraph)`, `.lifetime(.prototype)`, etc.
- `.injection { $0.property = $1 }`, `.injection(\.keyPath)`, `.injection(cycle: true) { ... }`.
- `.postInit { $0.start() }`.
- Modificators `arg($0)`, `many($0)`, `by(tag: ..., on: $0)`.
- Hierarchy: `DIFramework`, `DIPart`, `container.append(framework:)`, `container.append(part:)`, `import(...)`.
- Validation: `container.makeGraph().checkIsValid()`.

For most projects, no edits will be needed at all after upgrading to 6.0.0 — except for `@MainActor` registrations (see below).

## Registering `@MainActor` classes: `register(main:)`

This is the main new tool for projects that aren't ready to raise their deployment target to iOS 17. A new `container.register(main: ...)` overload registers a `@MainActor` initializer correctly **on every iOS starting from iOS 13**:

```swift
@MainActor
final class UserListViewModel {
    init(repo: UserRepository) { /* ... */ }
}

// Registration — works on any iOS:
container.register(main: UserListViewModel.init)

// Resolving from any context — the library will hop onto MainActor itself:
let vm: UserListViewModel = await container.resolve()
```

Under the hood `register(main:)` uses `MainActor.assumeIsolated` or `DispatchQueue.main.sync`, depending on the thread it's called from.

**If your minimum is iOS 17+**, you can register `@MainActor` initializers without `main:` as well:
```swift
// iOS 17+ only — the compiler picks the @isolated(any) overload.
container.register(UserListViewModel.init)
```

For projects on iOS < 17 the `main:`-less form won't compile (Swift can't pick a matching overload).

## What's new — Swift Concurrency (recommended on iOS 17+)

### Asynchronous component registration

```swift
container.register { await Service(dep: $0) }
```

### Asynchronous `.injection` and `.postInit`

```swift
container.register { await MyActor(dep: $0) }
    .injection { await $0.setup($1) }
    .postInit { await $0.start() }
```

### `actor` classes and arbitrary `@globalActor`

```swift
@globalActor
actor MyGlobalActor { static let shared = MyGlobalActor() }

@MyGlobalActor
final class MyService { init() {} }

// iOS 17+ only:
container.register(MyService.init)
let s: MyService = await container.resolve()
```

## Sync vs Async resolve

This is the central public-API change. Previously there was a single `resolve()`. Now there are two paths.

### From a synchronous context

Unchanged:
```swift
let service: MyService = container.resolve()
```

### From an asynchronous context — two options

**1) `await container.resolve()` — async path.**
The library picks the correct actor and runs `async` initializers and `async` injections. Use this option when at least one component in the graph is registered with `register { await ... }`, has async `.injection`/`.postInit`, or is a `@MainActor`/`actor` class.

```swift
Task {
    let vm: UserListViewModel = await container.resolve()
}
```

**2) `container.resolve(sync: ())` — synchronous path from an async context.**
The `sync: ()` parameter is a disambiguator that tells the compiler to pick the synchronous overload without `await`. Use it when the graph is fully synchronous and you want to avoid context switches (for example, inside `Task { @MainActor in ... }`).

```swift
Task { @MainActor in
    let svc: MyService = container.resolve(sync: ())
}
```

⚠️ If the graph contains async registrations, `resolve(sync: ())` will trap. When in doubt, prefer `await container.resolve()`.

## Lazy, Provider, and their async counterparts

In 5.x.x, `Lazy` and `Provider` came from the external **SwiftLazy** package. In 6.0.0 that dependency is **removed** — the types are bundled directly into the library and available without an extra import.

```swift
// 5.x.x:
import SwiftLazy
import DITranquillity

// 6.0.0:
import DITranquillity   // Lazy/Provider are already here
```

### Synchronous wrappers

Same usage as before:
- `Lazy<Value>` — lazily-initialized cached value.
- `Provider<Value>` — factory without caching.
- `Provider1<Value, Arg1>` … `Provider5<Value, Arg1, ..., Arg5>` — typed factories with runtime arguments.
- `ProviderArgs<Value>` — factory with dynamic `AnyArguments`.

### New asynchronous wrappers (actor-based)

Use these when the factory produces an `async`/`@MainActor`/`actor` object:

- `AsyncLazy<Value>` — async counterpart of `Lazy`, cached.
- `AsyncProvider<Value>` — async factory without caching.
- `AsyncProvider1<Value, Arg1>` … `AsyncProvider5<Value, Arg1, ..., Arg5>`
- `AsyncProviderArgs<Value>`

Example:
```swift
final class Coordinator {
    private let vmProvider: AsyncProvider<UserListViewModel>

    init(vmProvider: AsyncProvider<UserListViewModel>) {
        self.vmProvider = vmProvider
    }

    func show() {
        Task { @MainActor in
            let vm = await vmProvider.value
            // ...
        }
    }
}
```

Rule of thumb: **if the registration is async, use the Async wrapper**; if it's synchronous, the regular `Lazy`/`Provider` is fine.

## Removed and renamed

| Was (5.x.x) | Is now (6.0.0) |
|-------------|----------------|
| `DISetting.Defaults.multiThread` | removed (always thread-safe) |
| `DISetting.Defaults.injectToSubviews` | removed |
| `import SwiftLazy` | not needed — types are bundled |
| Auto-injection into UIView subviews | removed |
| Documentation `storyboard.md`, `view_injection.md` | removed (storyboard-based UI injection is no longer a first-class scenario) |

## Migration checklist

1. Bump the dependency tag to `6.0.0` in `Package.swift` / `Cartfile`.
2. Remove `import SwiftLazy` (or replace with `import DITranquillity`) — the build should pass on the bundled types with the same names.
3. Remove `DISetting.Defaults.multiThread = ...` and `DISetting.Defaults.injectToSubviews = ...` assignments, if you had any.
4. If you have `@MainActor` class registrations, switch them to `container.register(main: MyClass.init)`. If your project's minimum is iOS 17+, you can keep the old form `container.register(MyClass.init)`.
5. If you call `container.resolve()` without `await` inside a `Task` / async method, decide:
   - The graph is fully synchronous → `container.resolve(sync: ())`.
   - The graph contains `@MainActor`/`actor`/async registrations → `await container.resolve()`.
6. If you plan to use the full async API (`register { await ... }`, `.injection { await ... }`, `.postInit { await ... }`, arbitrary `@globalActor`), raise the minimum to iOS 17+.
7. Run `container.makeGraph().checkIsValid()` (in debug builds) and your full test suite — pay special attention to scenarios with Lazy/Provider in cycles and large graphs.

## What's next?

- Up-to-date usage examples — in `README.md`.
- Detailed description of new capabilities — in the updated docs in `Documentation/en/`.
- Per-release change history — in [CHANGELOG](../../CHANGELOG.md).
