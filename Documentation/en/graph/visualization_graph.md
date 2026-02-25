# Dependency Graph Visualization

> **Status:** In Development/On Pause

Dependency graph visualization allows you to visually see the structure of your application and quickly find problematic areas.

## Current Capabilities

Currently, the library provides full access to the graph structure through the [Graph API](get_graph.md), which allows:

- Getting a list of all components and their dependencies
- Finding cycles in the graph
- Checking the graph for validity

## Export to DOT Format

You can use the [library](https://github.com/ivlevAstef/DITranquillityGraphviz) to create a DOT file from the dependency graph.

The library allows visualizing the graph, taking into account modularity and other dependency features, but it is poorly documented and not updated.

OR

You can export the graph to [DOT](https://graphviz.org/doc/info/lang.html) format yourself for visualization with [Graphviz](https://graphviz.org/):

```swift
extension DIGraph {
    func exportToDOT() -> String {
        var result = "digraph DependencyGraph {\n"
        result += "    rankdir=LR;\n"
        result += "    node [shape=box];\n\n"

        // Add vertices
        for (index, vertex) in vertices.enumerated() {
            let label: String
            let color: String

            switch vertex {
            case .component(let component):
                label = "\(component.componentInfo.type)"
                color = "lightblue"
            case .argument(let arg):
                label = "arg: \(arg.type)"
                color = "lightyellow"
            case .unknown(let unknown):
                label = "?: \(unknown.type)"
                color = "lightcoral"
            }

            result += "    node\(index) [label=\"\(label)\", fillcolor=\"\(color)\", style=filled];\n"
        }

        result += "\n"

        // Add edges
        for (fromIndex, edges) in adjacencyList.enumerated() {
            for (edge, toIndices) in edges {
                let style = edge.optional ? "dashed" : "solid"
                let color = edge.cycle ? "red" : (edge.delayed ? "blue" : "black")

                for toIndex in toIndices {
                    result += "    node\(fromIndex) -> node\(toIndex) [style=\(style), color=\(color)];\n"
                }
            }
        }

        result += "}\n"
        return result
    }
}

// Usage
let graph = container.makeGraph()
let dot = graph.exportToDOT()

// Save to file
try? dot.write(toFile: "dependency_graph.dot", atomically: true, encoding: .utf8)

// Then run in terminal:
// dot -Tpng dependency_graph.dot -o dependency_graph.png
```

## Example Output

For a simple application with MVP architecture:

```
digraph DependencyGraph {
    rankdir=LR;
    node [shape=box];

    node0 [label="UserService", fillcolor="lightblue", style=filled];
    node1 [label="UserPresenter", fillcolor="lightblue", style=filled];
    node2 [label="UserViewController", fillcolor="lightblue", style=filled];
    node3 [label="APIClient", fillcolor="lightblue", style=filled];

    node1 -> node0 [style=solid, color=black];
    node1 -> node2 [style=solid, color=red];
    node2 -> node1 [style=solid, color=red];
    node0 -> node3 [style=solid, color=black];
}
```

## Legend

| Element | Meaning |
|---------|---------|
| Blue node | Registered component |
| Yellow node | Argument (arg) |
| Red node | Unknown type (missing registration) |
| Solid line | Required dependency |
| Dashed line | Optional dependency |
| Black line | Normal dependency |
| Red line | Cyclic dependency (cycle: true) |
| Blue line | Delayed dependency (Lazy/Provider) |

## Visualization Tool Integration

### Graphviz

```bash
# Installation (macOS)
brew install graphviz

# Generate image
dot -Tpng dependency_graph.dot -o dependency_graph.png
dot -Tsvg dependency_graph.dot -o dependency_graph.svg
```

### Online Visualizers

You can use online tools for DOT file visualization:
- [GraphvizOnline](https://dreampuf.github.io/GraphvizOnline/)
- [Edotor](https://edotor.net/)
- [viz-js.com](http://viz-js.com/)

## Extended Example with Modules

```swift
extension DIGraph {
    func exportToDOTWithModules() -> String {
        var result = "digraph DependencyGraph {\n"
        result += "    rankdir=TB;\n"
        result += "    compound=true;\n\n"

        // Group by frameworks
        var frameworkVertices: [String: [Int]] = [:]

        for (index, vertex) in vertices.enumerated() {
            if case .component(let component) = vertex {
                let frameworkName = component.framework.map { String(describing: $0) } ?? "Main"
                frameworkVertices[frameworkName, default: []].append(index)
            }
        }

        // Create subgraphs for each framework
        for (framework, indices) in frameworkVertices {
            result += "    subgraph cluster_\(framework.replacingOccurrences(of: " ", with: "_")) {\n"
            result += "        label=\"\(framework)\";\n"
            result += "        style=filled;\n"
            result += "        color=lightgrey;\n"

            for index in indices {
                if case .component(let component) = vertices[index] {
                    result += "        node\(index) [label=\"\(component.componentInfo.type)\"];\n"
                }
            }

            result += "    }\n\n"
        }

        // Add edges
        for (fromIndex, edges) in adjacencyList.enumerated() {
            for (_, toIndices) in edges {
                for toIndex in toIndices {
                    result += "    node\(fromIndex) -> node\(toIndex);\n"
                }
            }
        }

        result += "}\n"
        return result
    }
}
```

This variant groups components by frameworks, which is convenient for analyzing modular architecture.
