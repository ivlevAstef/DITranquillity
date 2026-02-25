# Getting the Dependency Graph

Getting the graph is one of the important features of this library. The ability to get the graph allows you to check it for correctness, find cycles, and analyze the dependency structure. Graph validation is covered in a separate [chapter](graph_validation.md), and in this chapter we'll look at how to get the graph and what information it stores.

## Creating the Graph

To get the dependency graph, call the `makeGraph()` method on the container:

```swift
let container = DIContainer()
// ... component registration ...

let graph: DIGraph = container.makeGraph()
```

> **Important:** The graph is created for the current container state and is not automatically updated when new dependencies are registered. If you add new components after creating the graph, you'll need to create a new graph.

## DIGraph

The graph is represented as an [adjacency list](https://en.wikipedia.org/wiki/Adjacency_list) and has the following structure:

```swift
public final class DIGraph: @unchecked Sendable {
    /// Adjacency list type: array of pairs (edge, target vertex indices)
    public typealias AdjacencyList = [[(edge: DIEdge, toIndices: [Int])]]

    /// All vertices of the graph
    public let vertices: [DIVertex]

    /// Adjacency list for graph navigation
    public let adjacencyList: AdjacencyList
}
```

It's guaranteed that the number of vertices (`vertices.count`) equals the number of elements in the adjacency list (`adjacencyList.count`).

### Data Structure

- **Vertices** (`vertices`) — array of all graph nodes. They can be accessed by index.
- **Adjacency list** (`adjacencyList`) — for each vertex, contains a list of outgoing edges with information about target vertices.

Feature: a single edge can lead to multiple vertices. This is necessary for correctly describing the [many](../core/modificated_injection.md#multiple-injection-many) modifier.

> If you don't use `many()` and the graph is valid, `toIndices` will always have one element.

### Graph Traversal

Example of breadth-first search (BFS) to find all reachable vertices:

```swift
let graph = container.makeGraph()

func findReachableVertices(from startIndex: Int) -> Set<Int> {
    var visited: Set<Int> = []
    var queue: [Int] = [startIndex]

    while let currentIndex = queue.first {
        queue.removeFirst()

        guard !visited.contains(currentIndex) else { continue }
        visited.insert(currentIndex)

        // Get all target indices for current vertex (merging all toIndices arrays from specified edges)
        let nextIndices = graph.adjacencyList[currentIndex].flatMap { $0.toIndices }
        for nextIndex in nextIndices where !visited.contains(nextIndex) {
            queue.append(nextIndex)
        }
    }

    return visited
}

// Usage
let reachable = findReachableVertices(from: 0)
print("Reachable vertices: \(reachable.count)")
```

### Graph Analysis

```swift
let graph = container.makeGraph()

// Count components
let componentCount = graph.vertices.filter {
    if case .component = $0 { return true }
    return false
}.count

// Find missing dependencies
let missingDependencies = graph.vertices.compactMap { vertex -> DIAType? in
    if case .unknown(let unknown) = vertex {
        return unknown.type
    }
    return nil
}

if !missingDependencies.isEmpty {
    print("⚠️ Dependencies not found for types:")
    for type in missingDependencies {
        print("  - \(type)")
    }
}
```

## DIVertex

A graph vertex can be one of three kinds:

```swift
public enum DIVertex: Hashable, Sendable {
    /// Registered component
    case component(DIComponentVertex)

    /// Argument passed during resolve
    case argument(DIArgumentVertex)

    /// Unknown (unregistered) type
    case unknown(DIUnknownVertex)
}
```

### Vertex Order

- **Components** are at the beginning of the vertex list
- **Arguments** and **unknown types** are placed after components

> **Important:** A separate vertex is created for each use of `arg()` or missing dependency, even if the types match.

### DIArgumentVertex

Created when using [argument injection](../core/modificated_injection.md#arguments-arg):

```swift
public struct DIArgumentVertex: Hashable, Sendable {
    /// Unique identifier in the graph
    public let id: Int

    /// Argument type
    public let type: DIAType
}
```

### DIUnknownVertex

Created when no registered component is found for a dependency:

```swift
public struct DIUnknownVertex: Hashable, Sendable {
    /// Unique identifier in the graph
    public let id: Int

    /// Type for which no registration was found
    public let type: DIAType
}
```

### DIComponentVertex

Vertex representing a registered component:

```swift
public struct DIComponentVertex: Hashable, Sendable {
    /// Component information (type, file, registration line)
    public let componentInfo: DIComponentInfo

    /// Component lifetime
    public let lifeTime: DILifeTime

    /// Priority (default, test)
    public let priority: DIComponentPriority

    /// Whether component can be initialized
    public let canInitialize: Bool

    /// Marked as root
    public let isRoot: Bool

    /// Marked as unused (ignored during validation)
    public let unused: Bool

    /// Alternative types (via .as())
    public let alternativeTypes: [ComponentAlternativeType]

    /// Framework where registered
    public let framework: DIFramework.Type?

    /// Part where registered
    public let part: DIPart.Type?
}
```

#### Component Properties

| Property | Description |
|----------|-------------|
| `componentInfo` | Identification information: type, file and line of registration |
| `lifeTime` | Lifetime: `prototype`, `objectGraph`, `perContainer`, `perRun`, `single`, `custom` |
| `priority` | Priority: `default` or `test` (set via `.default()` or `.test()`) |
| `canInitialize` | `true` if initialization method was provided, `false` for `register(Type.self)` |
| `isRoot` | `true` if component is marked with `.root()` |
| `alternativeTypes` | Types added via `.as()`: just type, type+tag, or type+name |
| `framework` / `part` | Module and part where registration occurred |

## DIEdge

Information about an edge (dependency) between vertices:

```swift
public final class DIEdge: Hashable {
    /// Dependency from initialization method
    public let initial: Bool

    /// Marked as cycle break (.injection(cycle: true, ...))
    public let cycle: Bool

    /// Optional dependency (Optional<T>)
    public let optional: Bool

    /// Multiple injection (many())
    public let many: Bool

    /// Delayed injection (Lazy, Provider, AsyncLazy, AsyncProvider)
    public let delayed: Bool

    /// Asynchronous delayed injection (AsyncLazy, AsyncProvider)
    public let async: Bool

    /// Tags for filtering
    public let tags: [DITag]

    /// Name for named injection
    public let name: String?

    /// Base dependency type
    public let type: DIAType
}
```

### Edge Property Descriptions

| Property | Description |
|----------|-------------|
| `initial` | `true` — from initializer, `false` — from `.injection()` |
| `cycle` | `true` only for `.injection(cycle: true, ...)`. If `initial == true`, then `cycle` is always `false` |
| `optional` | `true` if dependency type is `Optional<T>` |
| `many` | `true` for [multiple injection](../core/modificated_injection.md#multiple-injection-many) |
| `delayed` | `true` for [delayed injection](../core/delayed_injection.md) (`Lazy`, `Provider`, `AsyncLazy`, `AsyncProvider`) |
| `async` | `true` for asynchronous delayed injection (`AsyncLazy`, `AsyncProvider`) |
| `tags` | Array of [tags](../core/modificated_injection.md#tags) for component search |
| `name` | Name for [named injection](../core/modificated_injection.md#tags) |
| `type` | Base type without wrappers (Optional, Lazy, etc.) |

## DICycle and Cycle Detection

The graph allows finding all cyclic dependencies:

```swift
let graph = container.makeGraph()

// Find all cycles
let cycles = graph.findCycles()

// Or find only cycles reachable from root components
let rootCycles = graph.findRootCycles()

for cycle in cycles {
    print("Found cycle of \(cycle.vertexIndices.count) vertices")
}
```

### DICycle Structure

```swift
public struct DICycle: Sendable {
    /// Indices of vertices forming the cycle
    public let vertexIndices: [Int]

    /// Edges between cycle vertices
    public let edges: [DIEdge]
}
```

The length of `vertexIndices` and `edges` is always the same. Transition scheme:

```
vertexIndices[i] --edges[i]--> vertexIndices[(i + 1) % count]
```

That is, the i-th edge connects the i-th vertex to the (i+1)-th, and the last edge closes the cycle to the first vertex.

### Cycle Analysis Example

```swift
let graph = container.makeGraph()
let cycles = graph.findCycles()

for (index, cycle) in cycles.enumerated() {
    print("Cycle #\(index + 1):")

    for i in 0..<cycle.vertexIndices.count {
        let vertex = graph.vertices[cycle.vertexIndices[i]]
        let edge = cycle.edges[i]

        if case .component(let component) = vertex {
            let edgeInfo = edge.initial ? "init" : (edge.cycle ? "cycle injection" : "injection")
            print("  \(component.componentInfo) [\(edgeInfo)]")
        }
    }
}
```

## Graph Validation

Based on the obtained graph, the library offers comprehensive [dependency graph validation](graph_validation.md):

```swift
let graph = container.makeGraph()

if graph.checkIsValid() {
    print("✅ Dependency graph is valid")
} else {
    print("❌ Problems found in graph")
}
```

> **Recommendation:** Use validation in debug builds for early detection of configuration errors. This will significantly save time during development and reduce runtime errors.
