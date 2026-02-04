# Получение графа зависимостей

Получение графа — одна из важных особенностей этой библиотеки. Возможность получить граф позволяет проверить его на корректность, найти циклы и проанализировать структуру зависимостей. Тема проверки графа раскрыта в отдельной [главе](graph_validation.md), а в этой главе рассмотрим, как получить граф и какую информацию он хранит.

## Создание графа

Для получения графа зависимостей вызовите метод `makeGraph()` у контейнера:

```swift
let container = DIContainer()
// ... регистрация компонентов ...

let graph: DIGraph = container.makeGraph()
```

> **Важно:** Граф создается для текущего состояния контейнера и автоматически не обновляется при регистрации новых зависимостей. Если вы добавите новые компоненты после создания графа, потребуется создать новый граф.

## DIGraph

Граф представлен [списком смежности](https://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D1%81%D0%BC%D0%B5%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8) и имеет следующую структуру:

```swift
public final class DIGraph: @unchecked Sendable {
    /// Тип списка смежности: массив пар (ребро, индексы целевых вершин)
    public typealias AdjacencyList = [[(edge: DIEdge, toIndices: [Int])]]

    /// Все вершины графа
    public let vertices: [DIVertex]

    /// Список смежности для навигации по графу
    public let adjacencyList: AdjacencyList
}
```

Гарантируется, что количество вершин (`vertices.count`) равно количеству элементов списка смежности (`adjacencyList.count`).

### Структура данных

- **Вершины** (`vertices`) — массив всех узлов графа. К ним можно обращаться по индексу.
- **Список смежности** (`adjacencyList`) — для каждой вершины содержит список исходящих рёбер с информацией о целевых вершинах.

Особенность: по одному ребру возможен переход в несколько вершин. Это необходимо для корректного описания модификатора [many](../core/modificated_injection.md#Множественное-внедрение).

> Если вы не используете `many()` и граф корректен, то в `toIndices` всегда будет один элемент.

### Обход графа

Пример обхода в ширину (BFS) для нахождения всех достижимых вершин:

```swift
let graph = container.makeGraph()

func findReachableVertices(from startIndex: Int) -> Set<Int> {
    var visited: Set<Int> = []
    var queue: [Int] = [startIndex]

    while let currentIndex = queue.first {
        queue.removeFirst()

        guard !visited.contains(currentIndex) else { continue }
        visited.insert(currentIndex)

        // Получаем все целевые индексы для текущей вершины (объединив все массивы toIndices из указанных ребер)
        let nextIndices = graph.adjacencyList[currentIndex].flatMap { $0.toIndices }
        for nextIndex in nextIndices where !visited.contains(nextIndex) {
            queue.append(nextIndex)
        }
    }

    return visited
}

// Использование
let reachable = findReachableVertices(from: 0)
print("Достижимые вершины: \(reachable.count)")
```

### Анализ графа

```swift
let graph = container.makeGraph()

// Подсчёт компонентов
let componentCount = graph.vertices.filter {
    if case .component = $0 { return true }
    return false
}.count

// Поиск отсутствующих зависимостей
let missingDependencies = graph.vertices.compactMap { vertex -> DIAType? in
    if case .unknown(let unknown) = vertex {
        return unknown.type
    }
    return nil
}

if !missingDependencies.isEmpty {
    print("⚠️ Не найдены зависимости для типов:")
    for type in missingDependencies {
        print("  - \(type)")
    }
}
```

## DIVertex

Вершина графа может быть трёх видов:

```swift
public enum DIVertex: Hashable, Sendable {
    /// Зарегистрированный компонент
    case component(DIComponentVertex)

    /// Аргумент, передаваемый при resolve
    case argument(DIArgumentVertex)

    /// Неизвестный (незарегистрированный) тип
    case unknown(DIUnknownVertex)
}
```

### Порядок вершин

- **Компоненты** находятся в начале списка вершин
- **Аргументы** и **неизвестные типы** располагаются после компонентов

> **Важно:** Для каждого использования `arg()` или отсутствующей зависимости создаётся отдельная вершина, даже если типы совпадают.

### DIArgumentVertex

Создается при использовании [внедрения аргумента](../core/modificated_injection.md#Аргумент):

```swift
public struct DIArgumentVertex: Hashable, Sendable {
    /// Уникальный идентификатор в графе
    public let id: Int

    /// Тип аргумента
    public let type: DIAType
}
```

### DIUnknownVertex

Создается когда для зависимости не найден зарегистрированный компонент:

```swift
public struct DIUnknownVertex: Hashable, Sendable {
    /// Уникальный идентификатор в графе
    public let id: Int

    /// Тип, для которого не найдена регистрация
    public let type: DIAType
}
```

### DIComponentVertex

Вершина, представляющая зарегистрированный компонент:

```swift
public struct DIComponentVertex: Hashable, Sendable {
    /// Информация о компоненте (тип, файл, строка регистрации)
    public let componentInfo: DIComponentInfo

    /// Время жизни компонента
    public let lifeTime: DILifeTime

    /// Приоритет (default, test)
    public let priority: DIComponentPriority

    /// Может ли компонент быть инициализирован
    public let canInitialize: Bool

    /// Помечен ли как root
    public let isRoot: Bool

    /// Помечен ли как unused (игнорируется при проверке)
    public let unused: Bool

    /// Альтернативные типы (через .as())
    public let alternativeTypes: [ComponentAlternativeType]

    /// Framework, в котором зарегистрирован
    public let framework: DIFramework.Type?

    /// Part, в которой зарегистрирован
    public let part: DIPart.Type?
}
```

#### Свойства компонента

| Свойство | Описание |
|----------|----------|
| `componentInfo` | Информация для идентификации: тип, файл и строка регистрации |
| `lifeTime` | Время жизни: `prototype`, `objectGraph`, `perContainer`, `perRun`, `single`, `custom` |
| `priority` | Приоритет: `default` или `test` (установленный через `.default()` или `.test()`) |
| `canInitialize` | `true` если передан метод инициализации, `false` для `register(Type.self)` |
| `isRoot` | `true` если компонент помечен как `.root()` |
| `alternativeTypes` | Типы, добавленные через `.as()`: просто тип, тип+тэг или тип+имя |
| `framework` / `part` | Модуль и часть, где произошла регистрация |

## DIEdge

Информация о ребре (зависимости) между вершинами:

```swift
public final class DIEdge: Hashable {
    /// Зависимость из метода инициализации
    public let initial: Bool

    /// Помечена как разрыв цикла (.injection(cycle: true, ...))
    public let cycle: Bool

    /// Опциональная зависимость (Optional<T>)
    public let optional: Bool

    /// Множественное внедрение (many())
    public let many: Bool

    /// Отложенное внедрение (Lazy, Provider, AsyncLazy, AsyncProvider)
    public let delayed: Bool

    /// Асинхронное отложенное внедрение (AsyncLazy, AsyncProvider)
    public let async: Bool

    /// Тэги для фильтрации
    public let tags: [DITag]

    /// Имя для именованного внедрения
    public let name: String?

    /// Базовый тип зависимости
    public let type: DIAType
}
```

### Описание свойств рёбер

| Свойство | Описание |
|----------|----------|
| `initial` | `true` — из инициализатора, `false` — из `.injection()` |
| `cycle` | `true` только для `.injection(cycle: true, ...)`. Если `initial == true`, то `cycle` всегда `false` |
| `optional` | `true` если тип зависимости `Optional<T>` |
| `many` | `true` для [множественного внедрения](../core/modificated_injection.md#Множественное-внедрение) |
| `delayed` | `true` для [отложенного внедрения](../core/delayed_injection.md) (`Lazy`, `Provider`, `AsyncLazy`, `AsyncProvider`) |
| `async` | `true` для асинхронного отложенного внедрения (`AsyncLazy`, `AsyncProvider`) |
| `tags` | Массив [тэгов](../core/modificated_injection.md#Тэги) для поиска компонента |
| `name` | Имя для [именованного внедрения](../core/modificated_injection.md#Именованное-внедрение) |
| `type` | Базовый тип без обёрток (Optional, Lazy, etc.) |

## DICycle и поиск циклов

Граф позволяет найти все циклические зависимости:

```swift
let graph = container.makeGraph()

// Найти все циклы
let cycles = graph.findCycles()

// Или найти только циклы, достижимые из root-компонентов
let rootCycles = graph.findRootCycles()

for cycle in cycles {
    print("Найден цикл из \(cycle.vertexIndices.count) вершин")
}
```

### Структура DICycle

```swift
public struct DICycle: Sendable {
    /// Индексы вершин, образующих цикл
    public let vertexIndices: [Int]

    /// Рёбра между вершинами цикла
    public let edges: [DIEdge]
}
```

Длина `vertexIndices` и `edges` всегда одинакова. Схема перехода:

```
vertexIndices[i] --edges[i]--> vertexIndices[(i + 1) % count]
```

То есть i-е ребро соединяет i-ю вершину с (i+1)-й, а последнее ребро замыкает цикл на первую вершину.

### Пример анализа циклов

```swift
let graph = container.makeGraph()
let cycles = graph.findCycles()

for (index, cycle) in cycles.enumerated() {
    print("Цикл #\(index + 1):")

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

## Валидация графа

На основе полученного графа библиотека предлагает комплексную [проверку графа зависимостей](graph_validation.md):

```swift
let graph = container.makeGraph()

if graph.checkIsValid() {
    print("✅ Граф зависимостей корректен")
} else {
    print("❌ Обнаружены проблемы в графе")
}
```

> **Рекомендация:** Используйте валидацию в debug-сборках для раннего обнаружения ошибок конфигурации. Это значительно сэкономит время при разработке и уменьшит количество runtime-ошибок.
