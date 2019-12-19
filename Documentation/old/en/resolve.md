# Разрешение зависимостей
Разрешение зависимостей - процесс, при котором создается запрашиваемый объект и все объекты, от которых он зависит.


##### Перед прочтением главы ознакомьтесь с другими главами:
* [Регистрация компонентов](registration.md)
* [Создание контейнера](build.md)

## По типу
Основной способ разрешения зависимостей - по типу. Такой способ похож на вызов обычного конструктора, но при этом происходит внедрение зависимых объектов.

Предположим, в программе зарегистрирован некоторый класс, и регистрировался он по типу:
```Swift
builder.register(type: Cat.self).initial { Cat() }
```
Был создан контейнер:
```Swift
let container = try! builder.build()
```

Теперь можно создать объект:
```Swift
let cat = try! container.resolve(Cat.self)
```

Данный пример не сильно наглядный, так как наш класс не имеет зависимостей и по факту можно спокойно вызвать конструктор. Поэтому приведу более сложный пример:
```Swift
builder.register{ Cat() }.as(Animal.self).check{$0}
builder.register{ BMW() }.as(Vehicle.self).check{$0}
builder.register(type: Home.init(animal:vehicle:))
...
let home = try! container.resolve(Home.self)
// дом имеет животное: кошку и имеет машину: BMW
```

## По типу и имени
В некоторых случаях, не достаточно только типа, так как по одному и тому же типу, может быть несколько разных экземпляров объекта. Простой пример: storyboard. В больших программах, количество storyboard-ов может быть больше одного и тогда каждому из них, стоит дать имя:
```Swift
builder.register{ UIStoryboard(name: "Main",...) }.set(name: "Main").lifetime(.single)
builder.register{ UIStoryboard(name: "Login",...) }.set(name: "Login").lifetime(.single)
```

Для их создания используется следующий синтаксис:
```Swift
let mainStoryboard = try! container.resolve(UIStoryboard.self, name: "Main")
let loginStoryboard = try! container.resolve(UIStoryboard.self, name: "Login")
```

Также стоит уточнить, что один и тот же объект, может иметь несколько имен:
```Swift
builder.register{ Cat() }.set(name: "Felix").set(name: "Carfield").lifetime(.single)
```

Не смотря на то, что время жизни объявлено как `single`, в программе будут два разных кота:
```Swift
let felix = try! container.resolve(Cat.self, name: "Felix")
let carfield = try! container.resolve(Cat.self, name: "Carfield")
assert(felix !== carfield)
```

## По умолчанию
В предыдущих примерах надо было обязательно указывать имя при разрешении зависимости. Напишем похожий пример, но для логгеров:
```Swift
builder.register{ FileLogger() }
    .set(name: "File")
    .as(Logger.self).check{$0}
    .lifetime(.single)
builder.register{ ConsoleLogger() }
  .set(name: "Console")
  .as(Logger.self).check{$0}
  .lifetime(.single)
builder.register{ OtherLogger() }
  .set(name: "Other")
  .as(Logger.self).check{$0}
  .lifetime(.single)
builder.register{ MainLogger() }
  .set(name: "Main")
  .as(Logger.self).check{$0}
  .lifetime(.single)
```
В это примере создается 4 разных логгера, но все они доступны по одному типу `Logger`. Если убрать у них указание имен или сделать имена одинаковыми, то во время создания контейнера будет брошено исключение (см. [Создание контейнера](build.md)). Но в программе должен быть один логгер, но при этом при логгировании нужно вызывать метод логгирования для всех логгеров:
```Swift
let logger = try! container.resolve(Logger.self)
logger.log("msg") // должен вызваться метод для FileLogger(), ConsoleLogger(), OtherLogger()
```
Такая программа кинет исключение, так как не сможет понять, какой логгер от нее требуют. Для таких случаев есть метод `set(.default)` для установки объекта "по умолчанию" :
```Swift
builder.register{ FileLogger() }
  .as(Logger.self).check{$0}
  .lifetime(.single)
builder.register{ ConsoleLogger() }
  .as(Logger.self).check{$0}
  .lifetime(.single)
builder.register{ OtherLogger() }
  .as(Logger.self).check{$0}
  .lifetime(.single)
builder.register{ MainLogger() }
  .set(.default)
  .as(Logger.self).check{$0}
  .lifetime(.single)
```
При таком объявлении, исключения не будет, как это было в прошлом примере, а создастся `MainLogger`, так как он отмечен "по умолчанию".

## Множественная
Но возникла другая проблема - теперь нельзя получить доступ к другим логгерам. Как вариант можно вернуть имена, но обращаться по имени будет неудобно, так как для этого надо знать все имена. Для таких случаев есть возможность запросить все объекты по типу:
```Swift
let loggers: [Logger] = try! container.resolveMany(Logger.self)
// [FileLogger, ConsoleLogger, OtherLogger, MainLogger]
```
Теперь опираясь на эти знания, можно улучшить `MainLogger`:
```Swift
builder.register{ try MainLogger(loggers: $0.resolveMany(Logger.self)) }
  .set(.default)
  .as(Logger.self).check{$0}
  .lifetime(.single)
```
Теперь` MainLogger` знает обо всех остальных логгерах. Обращаю также внимание, что из-за того что логгеры получаются внутри инициализации `MainLogger`, сам `MainLogger` не попадает в этот список. Но если получать логгеры внутри `injection` или в любой другой части программы, то будут получены все логгеры, в том числе и `MainLogger`.

Более подробная информация описана в главе: [Регистрация с указанием имени/множественная регистрация](multi_name_registration.md)

## Передача параметров
!! Данный функционал доступен, только если его подключить отдельно.

Так как метод инициализации является подобием конструктора, а в конструкторе можно указывать параметры, то необходимость передавать параметры во время исполнения напрашивается сама собой:
```Swift
builder.register(type: Cat.self)
  .initialWithArg { _, name in Cat(name: name) }
...

let felix = container.resolve(Cat.self, arg: "felix")
let tiger = container.resolve(Cat.self, arg: "tiger")
```
Мы создали двух котов, и дали им клички. Обращаю внимание, что в отличие от `set(name:)`, если мы пометим тип как единственный в системе, то не зависимо от того какие будут передаваться аргументы, создастся он всего один раз:
```Swift
builder.register(type: Cat.self)
  .initialWithArg { _, name in Cat(name: name) }
  .lifetime(.single)
...

let felix = container.resolve(Cat.self, arg: "felix")
let tiger = container.resolve(Cat.self, arg: "tiger")
assert(felix === tiger)
// felix.name === tiger.name === "felix"
```

## Автоматический вывод типов
Во всех предыдущих примерах тип указывался в скобках, но Swift имеет автоматический вывод типов, и этим стоит воспользоваться:
```Swift
let cat = try! container.resolve(Cat.self)
let cat = try! container.resolve() as Cat
let cat: Cat = try! container.resolve()
var cat: Cat? = nil
cat = try? container.resolve()
var cat: Cat! = nil
cat = try! container.resolve()
```
Выше приведено несколько вариантов записи одного и того же выражения. Также продемонстрированно, что библиотека спокойно работает с Optional и ImplicitlyUnwrappedOptional типами.

## Для существующего объекта
В случае если объект создает программа своими собственными силами, но этот объект всё равно имеет зависимости, то можно попросить библиотеку встроить зависимости в уже существующий объект. При этом не стоит забывать, что зарегистрировать тип этого объекта нужно в любом случае:
```Swift
builder.register(type: Cat.self)
  .inejction { container, cat in cat.owner = try! container.resolve() }
  .initialNotNecessary() // Чтобы сказать компилятору, что у данного объекта может отсутствовать инициализатор
...
let cat = Cat()
try! container.resolve(cat)
```
Метод `initialNotNecessary()`, говорит библиотеке, что метод инициализации может отсутствовать. При этом это не означает, что его обязательно не должно быть. Вполне допустимо, что используется эта функция вместе с методами инициализации.

Также данная тема затрагивается в главе [Время жизни](lifetime.md)

## Сокращенный синтаксис
Писать каждый раз `try ... resolve` неудобно, а в большинстве случаев тип известен заранее и при регистрации не задано имя. Для таких случаев существует специальные укороченные записи:
```Swift
cat = try *container //cat = try container.resolve()
cat = *?container //cat = try? container.resolve()
cats = try **container //cats = try container.resolveMany()
```
Эта запись, похоже на вариант оператора разыменовывания, и имеет 3 вариантов: `*` `*?` `**`

!! Те, кто пользовался первой версией библиотеки, скорей всего заметили, что операторы: `*!`,`**!` были убраны. Причины этого решения можно найти в описании перехода с первой на вторую версию.

## Проверки и исключения
Читатель, наверное, обратил внимание, что везде используется `try`. Библиотека отсекла часть ошибок на стадии создания контейнера, но она не способна предугадать, как её будут использовать дальше. 
Во время разрешения зависимостей возможны следующие ошибки:
* Нет регистрации по указанному типу.
> Ошибка: **`DIError.typeIsNotFound(type:)`**  
> Параметры:  
>            type - тип, для которого не удалось найти регистрацию
***

* Нет регистрации по указанному типу и имени.
> Ошибка: **`DIError.typeIsNotFoundForName(type:,name:,typesInfo:)`**  
> Параметры:  
>            type - тип, для которого не удалось найти регистрацию с указанным именем  
>            name - имя, для которого не удалось найти регистрацию  
>            typesInfo - информация о регистрациях, которые были найдены для данного типа
***

* Нет метода инициализации с заданной сигнатурой для регистрации.
> Ошибка: **`DIError.initializationMethodWithSignatureIsNotFoundFor(typeInfo:,signature:)`**  
> Параметры:  
>            typeInfo - информация о регистрации, которая была выбрана для типа  
>            signature - сигнатура метода, которую не удалось найти
***

* Не указана регистрация по умолчанию.
> Ошибка: **`DIError.defaultTypeIsNotSpecified(type:,typesInfo:)`**  
> Параметры:  
>            type - тип, для которого не указана регистрация по умолчанию  
>            typesInfo - все регистрации для этого типа
***

* Рекурсивная инициализация объекта.
> Ошибка: **`DIError.recursiveInitialization(typeInfo:)`**  
> Параметры:  
>            typeInfo - информация о регистрации, которая содержит рекурсивную инициализацию
***

* Созданный объект, не соответствует запрашиваемому типу (см. примечания в [Создание контейнера](build.md))
> Ошибка: **`DIError.typeIsIncorrect(requestedType:, realType:, typeInfo:)`**  
> Параметры:  
>            requestedType - запрашиваемый тип  
>            realType - тип объекта, который был создан  
>            typeInfo – информация о регистрации, используемой для создания объекта
***

#### [Главная](main.md)
#### [Предыдущая глава "Создание контейнера"](build.md#Создание-контейнера)
#### [Следующая глава "Указанием имени/множественная регистрация"](multi_name_registration.md#Указанием-именимножественная-регистрация)
