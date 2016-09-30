# Регистрация с указанием имени/ множественная регистрация

## Множественная регистрация

Бывают случаи, когда мы хотим, чтобы для одного интерфейса, было несколько классов, но при этом нам не важны сами классы, нам важны все они вместе. Предположим у нас есть интерфейс Logger, и от него онаследованы: FileLogger, ConsoleLogger, ServerLogger. Теперь представим себе код регистрации:
```Swift
builder.register(FileLogger.self).asType(Logger.self).instanceSingle().initializer { FileLogger("file.txt") }
builder.register(ConsoleLogger.self).asType(Logger.self).instanceSingle().initializer { ConsoleLogger() }
builder.register(ServerLogger.self).asType(Logger.self).instanceSingle().initializer { ServerLogger("http://server.com/") }
```
Пожалуй я запишу тоже самое в более короткой форме:
```Swift
builder.register{ FileLogger("file.txt") }.asType(Logger.self).instanceSingle()
builder.register{ ConsoleLogger() }.asType(Logger.self).instanceSingle()
builder.register{ ServerLogger("http://server.com/") }.asType(Logger.self).instanceSingle()
```

Теперь чтобы, создать все 3 класса, или обратится к ним нам не нужно знать о них ничего мы можем написать просто:
```Swift
let loggers: [Logger] = try scope.resolveMany()
```
и у нас будет все логеры которые мы зарегестрировали в программе.

## Указание Стандартной (Default) зависимости
В предыдущем примере, есть проблема - если мы запросим одни Logger, то библиотека не сможет понять какой именно логер нам нужен. С другой стороны, в предыдущем примере, и не понятно какой должен быть "стандартны". Но мы можем дописать код:
```Swift
builder.register{ AllLogger() }.asType(Logger.self).instanceSingle()
  .dependency { s, log in log.loggers = try! s.resolveMany().filter{ $0 !=== log } }
  .asDefault()
```

Теперь у библиотеке мы можем запросить Logger, и она будет знать, что нужно выдать тип AllLogger, так как он объявлен как default. Также обращаю внимание как легко, мы в него встроили все логгеры которые зарегестрированы в системе. мы просто запросили все (так как мы сами являемся логером, то этого нельзя делать в initializer), и убрали из всех себя.

Также этот пример можно переписать, еще более красиво воспользовавшись, одной из особенностей библиотеки - если внутри инициализации вызвал множественное разрешение зависимостей, то свой собственный тип будет проигнорирован. то есть мы можем переписать предыдущий код вот так:
```Swift
builder.register{ try! AllLogger(loggers: $0.resolveMany()) }.asType(Logger.self).instanceSingle()
  .asDefault()
```
Что является почти эквивалентом предыдущем коду, разве что мы указание всех логеров перенесли в конструктор. 

## Регистрация с указанием имени
Иногда бывают случаи, что один и тотже тип может быть в нескольких экземплярах в системе, но при этом не иметь иеархии наследования. Например карточка в магазине - она бывает gold, silver, bronze. Но все эти карточки ничем не отличаются, кроме процентной ставки. Возможно стоило бы создать Для каждого типа карточки свой класс, но мы бы хотели еще легко уметь сохранять карточку на диск. Мы можем каждой карточке дать имя, тогда мы сможем легко сохранять её на диск, и не создавать экземпляры класса. Мы это можем сделать следующим образом:
```Swift
builder.register(Card.self).asName("gold").instanceSingle().initializer { Card(percent:0.15) }
builder.register(Card.self).asName("silver").instanceSingle().initializer { Card(percent:0.10) }
builder.register(Card.self).asName("bronze").instanceSingle().initializer { Card(percent:0.7) }
```

теперь у нас в системе есть 3 карточки, которые являются одним типом и каждая из них является единственной в системе. Чтобы получить к примеру gold карту, можно написать:
```Swift
let card: Card = scope.resolve("gold")
```

мы получили золотую карточку.