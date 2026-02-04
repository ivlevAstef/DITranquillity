# Визуализация графа зависимостей

> **Статус:** В разработке/На Паузе

Визуализация графа зависимостей позволяет наглядно увидеть структуру вашего приложения и быстро найти проблемные места. 

## Текущие возможности

На данный момент библиотека предоставляет полный доступ к структуре графа через [Graph API](get_graph.md), что позволяет:

- Получить список всех компонентов и их зависимостей
- Найти циклы в графе
- Проверить граф на валидность

## Экспорт в DOT формат

Вы можете воспользоваться [библиотекой](https://github.com/ivlevAstef/DITranquillityGraphviz) для создания DOT файла по графу зависимостей.

Библиотека позволяет визуализировать граф, с учетом модульности, и других особенностей зависимостей, но она плохо документирована, и не обновляется.

ИЛИ

Вы можете самостоятельно экспортировать граф в формат [DOT](https://graphviz.org/doc/info/lang.html) для визуализации с помощью [Graphviz](https://graphviz.org/):

```swift
extension DIGraph {
    func exportToDOT() -> String {
        var result = "digraph DependencyGraph {\n"
        result += "    rankdir=LR;\n"
        result += "    node [shape=box];\n\n"

        // Добавляем вершины
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

        // Добавляем рёбра
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

// Использование
let graph = container.makeGraph()
let dot = graph.exportToDOT()

// Сохранить в файл
try? dot.write(toFile: "dependency_graph.dot", atomically: true, encoding: .utf8)

// Затем выполнить в терминале:
// dot -Tpng dependency_graph.dot -o dependency_graph.png
```

## Пример вывода

Для простого приложения с MVP архитектурой:

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

## Легенда

| Элемент | Значение |
|---------|----------|
| Синий узел | Зарегистрированный компонент |
| Жёлтый узел | Аргумент (arg) |
| Красный узел | Неизвестный тип (отсутствует регистрация) |
| Сплошная линия | Обязательная зависимость |
| Пунктирная линия | Опциональная зависимость |
| Чёрная линия | Обычная зависимость |
| Красная линия | Циклическая зависимость (cycle: true) |
| Синяя линия | Отложенная зависимость (Lazy/Provider) |

## Интеграция с инструментами визуализации

### Graphviz

```bash
# Установка (macOS)
brew install graphviz

# Генерация изображения
dot -Tpng dependency_graph.dot -o dependency_graph.png
dot -Tsvg dependency_graph.dot -o dependency_graph.svg
```

### Онлайн-визуализаторы

Вы можете использовать онлайн-инструменты для визуализации DOT-файлов:
- [GraphvizOnline](https://dreampuf.github.io/GraphvizOnline/)
- [Edotor](https://edotor.net/)
- [viz-js.com](http://viz-js.com/)

## Расширенный пример с модулями

```swift
extension DIGraph {
    func exportToDOTWithModules() -> String {
        var result = "digraph DependencyGraph {\n"
        result += "    rankdir=TB;\n"
        result += "    compound=true;\n\n"

        // Группировка по фреймворкам
        var frameworkVertices: [String: [Int]] = [:]

        for (index, vertex) in vertices.enumerated() {
            if case .component(let component) = vertex {
                let frameworkName = component.framework.map { String(describing: $0) } ?? "Main"
                frameworkVertices[frameworkName, default: []].append(index)
            }
        }

        // Создаём подграфы для каждого фреймворка
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

        // Добавляем рёбра
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

Этот вариант группирует компоненты по фреймворкам, что удобно для анализа модульной архитектуры.
