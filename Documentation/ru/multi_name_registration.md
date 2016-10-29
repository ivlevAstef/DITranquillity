# Указанием имени/множественная регистрация

## Множественная регистрация

Иногда у одного интерфейса есть несколько реализаций, при этом в таких случаях очень редко нужно знать о деталях реализации, а нужен список объектов удовлетворяющих этому интерфейсу.
Примеров может быть много: UI, Game Objects... но я остановлюсь на самом простом и достаточно универсальном - логгере.
В простейшем случае Логгер можно представить как интерфейс `Logger`, в котором есть всего один метод: `log(msg:)`. Часто в программах вывод сообщения происходит не в одно место, а в несколько: файл, консоль, передается по сети. Библиотека позаботилась о таком случае:
```Swift
builder.register{ FileLogger("file.txt") }.asType(Logger.self).lifetime(.single) 
builder.register{ ConsoleLogger() }.asType(Logger.self).lifetime(.single) 
builder.register{ ServerLogger("http://server.com/") }.asType(Logger.self).lifetime(.single) 
```
И после можно легко создать все 3 класса логгера:
```Swift
let loggers: [Logger] = try! container.resolveMany()
```

## Указание зависимости по умолчанию

Предыдущий пример нельзя считать завершенным, так как чтобы записать в лог сообщение, нужно каждый раз писать цикл, что не очень удобно. Поэтому стоит добавить еще один логгер и объявить его "по умолчанию". Последнее нужно для возможности получить один экземпляр логгера, а не все вместе:
```Swift
builder.register{ AllLogger() }.asType(Logger.self).lifetime(.single)
  .dependency { sсope, log in log.loggers = try! sсope.resolveMany().filter{ $0 !=== log } }
  .asDefault()
```
После чего можно в любом месте программы написать:
```Swift
let logger: Logger = container.resolve()
```
и получить экземпляр класса `AllLogger`, который содержит все остальные логгеры.

Но такой, способ регистрации можно переписать на более красивый - без `filter`, который нужен, чтобы отсечь самого себя и предотвратить рекурсивный вызов:
```Swift
builder.register{ try! AllLogger(loggers: $0.resolveMany()) }
  .asType(Logger.self)
  .lifetime(.single)
  .asDefault()
```
Так как получение списка логгеров происходит внутри инициализации одного из логгеров, то это логгер будет проигнорирован - библиотека обнаружен рекурсивную инициализацию и в случае множественного разрешения проигнорирует её.

## Указание имени

И вроде все хорошо, но есть одно НО - нет возможности обратиться к конкретному логгеру. То есть если нужно записать сообщение только в файл, то нет возможности получить экземпляр нужного класса. Но и такая проблема решаемая:
```Swift
builder.register{ FileLogger("file.txt") }.asName("file").asType(Logger.self).lifetime(.single) 
builder.register{ ConsoleLogger() }.asName("console").asType(Logger.self).lifetime(.single) 
builder.register{ ServerLogger("http://server.com/") }.asName("server").asType(Logger.self).lifetime(.single) 
```
Каждой компоненте было дано имя, благодаря чему можно получить конкретный экземпляр логгера, при этом, не зная о его типе:
```Swift
let logger: Logger = try! container.resolve (name: "file")
```
более подробную информацию можно посмотреть в главе:  [Разрешение зависимостей](resolve.md)
P.S. Правда никто не запрещает написать вот так:
```Swift
builder.register{ FileLogger("file.txt") }.asSelf().asType(Logger.self).lifetime(.single) 
builder.register{ ConsoleLogger() }.asSelf().asType(Logger.self).lifetime(.single) 
builder.register{ ServerLogger("http://server.com/") }.asSelf().asType(Logger.self).lifetime(.single) 
```
и получать конкретный экземпляр логгера по типу.