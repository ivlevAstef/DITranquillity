# Логирование

Одна из ключевых особенностей библиотеки — наличие подробных логов, которые помогают понять, что происходит, и предупреждают о возможных проблемах.

## Настройка

### Функция логирования

По умолчанию логи выводятся через `print`:

```swift
print("\(logLevel): \(message)")
```

Для настройки своей функции логирования:

```swift
DISetting.Log.fun = { level, message, file, line in
    // Ваша логика
    MyLogger.log(level: level, message: message, file: file, line: line)
}
```

> **Важно:** Логирование синхронное. В релизе рекомендуется отключать логи для производительности.

### Символ табуляции

Логи добавляют табуляцию для вложенных объектов. По умолчанию используется символ таба:

```swift
DISetting.Log.tab = ">>"  // Изменить на ">>"
```

## Уровни логирования

| Уровень | Описание |
|---------|----------|
| `error` | Критическая ошибка. Программа упала или может упасть |
| `warning` | Предупреждение о потенциальных проблемах |
| `info` | Информация о информационных сценариях |
| `verbose` | Подробная отладочная информация |
| `none` | Полное отключение логов |

### Настройка уровня

```swift
// Показывать все логи до указанного уровня включительно
DISetting.Log.level = .verbose  // Все логи
DISetting.Log.level = .warning  // error + warning
DISetting.Log.level = .none     // Отключить логи
```

По умолчанию установлен уровень `.info`.

### Приоритет уровней

```
none < error < warning < info < verbose
```

## Описание сообщений

### Fatal Error (падение программы)

#### `Can't resolve type {type}. For more information see logs.`

**Причина:** Не удалось создать объект для указанного не-опционального типа.

**Решения:**
- Убедитесь, что тип зарегистрирован
- Проверьте предыдущие логи для деталей
- Используйте `Optional<Type>` если объект может отсутствовать

#### `Registration with type found {type}, but the registration return nil.`

**Причина:** Метод создания вернул `nil`, но тип внедряется как не-опциональный.

**Решение:** Измените тип зависимости на опциональный или убедитесь, что создание не возвращает `nil`.

#### `Can't cast {objtype} to {type}.`

**Причина:** Неверное использование `.as()` при регистрации.

**Решение:** Проверьте, что класс действительно реализует указанный протокол. Или используйте `.as(check:)

#### `Please inject this property from DI in file: {file} on line: {line}.`

**Причина:** `Lazy` или `Provider` инициализированы пустыми и не внедрены из DI.

**Решение:** Убедитесь, что свойство внедряется через `.injection()`.

### Error (ошибки)

#### `Until get argument. Not found extensions for {Component}`

**Причина:** Компонент ожидает `arg()`, но аргумент не передан при resolve.

**Решение:**
```swift
// Неправильно
let obj: MyClass = container.resolve()

// Правильно
let obj: MyClass = container.resolve(arg: "value")
```

Подробнее: [Модификаторы внедрения](modificated_injection.md#Аргумент)

#### `Are you using root components, but a root component was found that was not marked as root: {Component}`

**Причина:** При использовании root-компонентов найден resolve не-root компонента.

**Решение:** Добавьте `.root()` к компоненту или проверьте логику resolve.

#### `Until make extensions can't find component by type: {type}`

**Причина:** Не найден компонент для указанного типа при внедрении.

**Решение:** Зарегистрируйте компонент указанного типа.

#### `Until make extensions can't choose component by type: {type}`

**Причина:** Найдено несколько компонентов для типа, выбор неоднозначен.

**Решение:**
- Используйте тэги для различения
- Используйте `.default()` для указания приоритета
- Удалите лишние регистрации

### Info (информация)

#### `Not found {type}`

**Причина:** Не найден компонент для типа.

**Примечание:** Часто приводит к fatal error, если тип не опциональный.

### Verbose (отладка)

Подробные логи о процессе:
- Регистрация компонентов
- Начало/конец создания объектов
- Внедрение зависимостей
- Получение из кэша

## Рекомендации по настройке

### Разработка

```swift
#if DEBUG
DISetting.Log.level = .verbose
DISetting.Log.fun = { level, message, file, line in
    let emoji = switch level {
        case .error: "❌"
        case .warning: "⚠️"
        case .info: "ℹ️"
        case .verbose: "🔍"
        case .none: ""
    }
    print("\(emoji) [\(level)] \(message)")
}
#endif
```

### Продакшн

```swift
#if !DEBUG
DISetting.Log.level = .none  // Полное отключение
#endif
```

### Интеграция с логгерами

```swift
import os.log

let diLog = OSLog(subsystem: "com.app.di", category: "DITranquillity")

DISetting.Log.fun = { level, message, file, line in
    let osLogType: OSLogType = switch level {
        case .error: .fault
        case .warning: .error
        case .info: .info
        case .verbose: .debug
        case .none: .debug
    }

    os_log("%{public}@", log: diLog, type: osLogType, message)
}
```

### Сохранение в файл

```swift
DISetting.Log.fun = { level, message, file, line in
    let logEntry = "[\(Date())] [\(level)] \(file):\(line) - \(message)\n"

    if let data = logEntry.data(using: .utf8) {
        FileHandle.standardOutput.write(data)
        // Или запись в файл
    }
}
```

## Логи при валидации графа

При вызове `checkIsValid()` выводятся специальные логи о проблемах в графе:
- Отсутствующие зависимости
- Неоднозначные внедрения
- Проблемы с циклами
- Неиспользуемые компоненты

Подробнее: [Валидация графа](../graph/graph_validation.md)

## Отладка сложных случаев

### Включите verbose для проблемного участка

```swift
func debugResolve<T>(_ type: T.Type) -> T {
    let previousLevel = DISetting.Log.level
    DISetting.Log.level = .verbose

    let result: T = container.resolve()

    DISetting.Log.level = previousLevel
    return result
}
```

### Анализ графа

```swift
let graph = container.makeGraph()

// Найти неизвестные типы
let missing = graph.vertices.compactMap { vertex -> String? in
    if case .unknown(let unknown) = vertex {
        return String(describing: unknown.type)
    }
    return nil
}

print("Missing dependencies: \(missing)")
```

## Дополнительные ссылки

- [Валидация графа](../graph/graph_validation.md)
- [Получение графа](../graph/get_graph.md)
