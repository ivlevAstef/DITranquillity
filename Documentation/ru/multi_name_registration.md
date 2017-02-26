# Указанием имени/множественная регистрация

## Множественная регистрация

Иногда у одного интерфейса есть несколько реализаций, при этом в таких случаях очень редко нужно знать о деталях реализации, а нужен список объектов удовлетворяющих этому интерфейсу.
Примеров может быть много: UI, Game Objects... но я остановлюсь на самом простом и достаточно универсальном - логгере.
В простейшем случае Логгер можно представить как интерфейс `Logger`, в котором есть всего один метод: `log(msg:)`. Часто в программах вывод сообщения происходит не в одно место, а в несколько: файл, консоль, передается по сети. Библиотека позаботилась о таком случае:
```Swift
builder.register{ FileLogger("file.txt") }
  .as(Logger.self).check{$0}
  .lifetime(.single) 
builder.register{ ConsoleLogger() }
  .as(Logger.self).check{$0}
  .lifetime(.single) 
builder.register{ ServerLogger("http://server.com/") }
  .as(Logger.self).check{$0}
  .lifetime(.single) 
```

Как видим, мы создали 3 разных логгера. Чтобы получить их все нужно у контейнера вызвать метод `resolveMany`:
```Swift
let loggers: [Logger] = try! container.resolveMany()
```

## Указание зависимости по умолчанию

Предыдущий пример нельзя считать завершенным, так как чтобы записать в лог сообщение, нужно каждый раз писать цикл, что не очень удобно. Поэтому стоит добавить еще один логгер и объявить его "по умолчанию", с помощью функции `set(.default)`. Последнее нужно для возможности получить один экземпляр логгера, а не все вместе:
```Swift
builder.register{ AllLogger() }
  .as(Logger.self).check{$0}
  .lifetime(.single)
  .injection { c, log in log.loggers = try! c.resolveMany().filter{ $0 !=== log } }
  .set(.default)
```

После чего можно получить наш логгер:
```Swift
let logger: Logger = try! container.resolve()
```
Который является экземпляром класса `AllLogger`, который содержит все остальные логгеры.

Но такой, способ регистрации можно переписать на более красивый - без `filter`, который нужен, чтобы отсечь самого себя и предотвратить рекурсивный вызов:
```Swift
builder.register{ c in try AllLogger(loggers: c.resolveMany()) }
  .as(Logger.self).check{$0}
  .lifetime(.single)
  .set(.default)
```
Так как получение списка логгеров происходит внутри инициализации одного из логгеров, то это логгер будет проигнорирован - библиотека обнаружит рекурсивную инициализацию и в случае множественного разрешения проигнорирует её.

## Указание имени

И вроде все хорошо, но есть одно НО - нет возможности обратиться к конкретному логгеру. То есть если нужно записать сообщение только в файл, то нет возможности получить экземпляр нужного класса. Но и такая проблема решаемая:
```Swift
builder.register{ FileLogger("file.txt") }
  .set(name: "file")
  .as(Logger.self).check{$0}
  .lifetime(.single) 
builder.register{ ConsoleLogger() }
  .set(name: "console")
  .as(Logger.self).check{$0}
  .lifetime(.single) 
builder.register{ ServerLogger("http://server.com/") }
  .set(name: "server")
  .as(Logger.self).check{$0}
  .lifetime(.single) 
```
При каждой регистрации было дано имя, благодаря чему можно получить конкретный экземпляр логгера, при этом, не зная о его типе:
```Swift
let logger: Logger = try! container.resolve(name: "file")
```
более подробную информацию можно посмотреть в главе:  [Разрешение зависимостей](resolve.md)

Помимо этого никто не запрещает получать конкретный экзмепляр логгера по типу, для этого при регистрации стоит воспользоваться функцией `as(.self)`:
```Swift
builder.register{ FileLogger("file.txt") }
  .as(.self)
  .as(Logger.self).check{$0}
  .lifetime(.single) 
builder.register{ ConsoleLogger() }
  .as(.self)
  .as(Logger.self).check{$0}
  .lifetime(.single) 
builder.register{ ServerLogger("http://server.com/") }
  .as(.self)
  .as(Logger.self).check{$0}
  .lifetime(.single) 
```
и после помимо множественного получения можно получить конкретный экземпляр логгера по типу:
```Swift
let logger: ConsoleLogger = try! container.resolve()
```

#### [Главная](main.md)
#### [Предыдущая глава "Разрешение зависимостей"](resolve.md)
#### [Следующая глава "Время жизни"](lifetime.md)