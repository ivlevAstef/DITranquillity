# Поддержка модульности

Для удобства использования библиотеки в модульных приложениях существует два дополнительных уровня по мимо основного контейнера. Это "часть" и "фреймворк".
Эти абстракции позволят более удобно и одинаково структурировать код, и добавят возможностей.

## Часть
"Часть" позволяет некоторый функционал объединить в одном месте. Основное предназначение - структурирование кода. "Части" не имеют, какой либо логики, за исключением регистрации всего, что написано внутри.

Объявление:
```Swift
import DITranquillity

final class YourPart: DIPart {
    static func load(container: DIContainer) {
        container.register(...)
        container.register(...)
        container.register(...)
        container.register(...)
    }
}
```
Для включения части в ваш контейнер не стоит ручками вызывать функцию `load`. Для этого есть специальный синтаксис:
```Swift
container.append(part: YourPart.self)
```

> не советую внутри "части" подключать "фреймворки"

## Фреймворк
"Фреймворк" это "часть" с наворотами. Он также служит для структурирования, и является более высокоуровневым. Его объявление и использование сильно похожи.

Объявление:
```Swift
import DITranquillity

final class YourFramework: DIFramework {
    static func load(container: DIContainer) {
        container.append(part: YourPart.self)
        container.append(part: YourPart2.self)
        container.register(...)
    }
}
```
Включение в контейнер:
```Swift
container.append(framework: YourFramework.self)
```

### Возможности фреймворков
Фреймворк ограничивает область поиска, позволяя использовать одинаковые имена, в разных модулях. Но это не значит, что он не позволяет получать зависимости из соседних модулей - он лишь устанавливает предпочтения, на подобии того как это делает [`.default()`](registration_and_service.md#По-Умолчанию).
Давайте рассмотрим пример:

#### Пример
У вас есть два модуля, в каждом модуле есть свой Storyboard:
```Swift
/// Module1
container.registerStoryboard(name: "Module1Storyboard")
/// Module2
container.registerStoryboard(name: "Module2Storyboard")
```
Если в коде написать получение сторибоарда, то, компилятор будет ругаться что не может однозначно понять какой сторибоард вы от него хотите - ведь их два. И тогда придется получать его по имени. Это не приятно, но не очень большая проблема, если вы получаете его сразу из контейнера.

А что если вы его внедряете? Например в класс роутер? тогда синтаксис усложняется, да и еще в метод инициализации не получится внедрить. Не удобно. Но давайте расширим наш пример:
```Swift
final class Module1Framework: DIFramework {
    static func load(container: DIContainer) {
        container.registerStoryboard(name: "Module1Storyboard")
        container.register(Module1Router.init(storyboard:))
    }
}
/////
final class Module2Framework: DIFramework {
    static func load(container: DIContainer) {
        container.registerStoryboard(name: "Module2Storyboard")
        container.register(Module2Router.init(storyboard:))
    }
}
```
В таком примере если мы попробуем получить сторибоард на прямую из контейнера, то библиотека снова напишет о неопределенности, но это можно решить не только указав имя, но и указав фреймворк:
```Swift
let storyboard: UIStoryboard = container.resolve(from: Module2Framework.self)
```
Тем самым мы убрали зависимость от имени, и скрыли внутренние потроха реализации - более того имена сторибоардов могут быть одинаковые, и это будет работать.

Но помимо этого теперь можно создать оба роутера, не прикладывая никаких дополнительных усилий:
```Swift
let router1: Module1Router = container.resolve()
// router1.storyboard.name == "Module1Storyboard"
let router2: Module2Router = container.resolve()
// router2.storyboard.name == "Module2Storyboard"
```
Это работает так, из-за того что каждый класс привязан к фреймворку внутри которого он был создан. Тем самым при получении роутера библиотека знает, к какому фреймворку он относится, и использует эту информацию для получения сторибоарда.

Этот пример спокойно переносится на протоколы - бывают ситуации, что реализация одного протокола находится в нескольких модулях, и тогда подобная возможность очень сильно спасёт.

## Импорт фреймворка
Теперь представим, что фреймворков стало три. И третий фреймворк использует второй:
```Swift
final class Module3Framework: DIFramework {
    static func load(container: DIContainer) {
        // хочется получить storyboard из Module2
        container.register(Module3Router.init(storyboard:))
    }
}
```
Что же делать? В таких крайне редких ситуациях на помощь приходит `import`:
```Swift
final class Module3Framework: DIFramework {
    static func load(container: DIContainer) {
        container.import(Module2Framework.self)
        container.register(Module3Router.init(storyboard:))
    }
}
```
Тем самым если в третьем модуле не будет сторибоардов, или их будет слишком много для однозначного выбора, то будет взят сторибоард из второго модуля.

> Важно - импортирование не работает вложено. Каждый отдельный модуль просматривает связи только на один уровень вложенности. Это сделано намеренно, чтобы не усугублять и так относительно сложную логику получения зависимости.
