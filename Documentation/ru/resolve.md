# Разрешение зависимостей
Разрешение зависимостей - процесс, при котором создается запрашиваемый объект и все объекты, от которых он зависит.


##### Перед прочтением главы ознакомьтесь с другими главами:
* [Регистрация компонентов](registration.md)
* [Создание контейнера](build.md)

## По типу
Основной способ разрешения зависимостей - по типу. Такой способ похож на вызов обычного конструктора, но с внедрением зависимых объектов.

Предположим, в программе зарегистрирован некоторый класс, и регистрировался он по типу:
```Swift
builder.register(Cat.self).initializer { Cat() }
```
И был создан контейнер:
```Swift
let container = try! builder.build()
```

Теперь можно создать объект:
```Swift
let cat = try! container.resolve(Cat.self)
```

Данный пример не сильно наглядный, так как наш класс не имеет зависимостей и по факту можно спокойно вызвать конструктор. Поэтому приведу более сложный пример:
```Swift
builder.register{ Cat() }.asType(Animal.self)
builder.register{ BMW() }.asType(Vehicle.self)
builder.register{ try! Home(animal: $0.resolve(Animal.self), vehicle: $0.resolve(Vehicle.self)) }
...
let home = try! container.resolve(Home.self)
// дом имеет животное: кошку и имеет машину: BMW
```

## По типу и имени
В некоторых случаях, на нем достаточно только типа, так как по одному и тому же типу, может быть несколько разных экземпляров объекта. Простой пример: storyboard. В больших программах, количество storyboard-ов может быть больше одного и тогда каждому из них, стоит дать имя:
```Swift
builder.register{ UIStoryboard(name: "Main",...) }.asName("Main").lifetime(.single)
builder.register{ UIStoryboard(name: "Login",...) }.asName("Login").lifetime(.single)
```
После чего можно их создать:
```Swift
let mainStoryboard = try! container.resolve(UIStoryboard.self, name: "Main")
let loginStoryboard = try! container.resolve(UIStoryboard.self, name: "Login")
```

Также стоит уточнить, что один и тот же объект, может иметь несколько имен:
```Swift
builder.register{ Cat() }.asName("Felix").asName("Carfield").lifetime(.single)
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
builder.register{ FileLogger() }.asName("File").asType(Logger.self).lifetime(.single)
builder.register{ ConsoleLogger() }.asName("Console").asType(Logger.self).lifetime(.single)
builder.register{ OtherLogger() }.asName("Other").asType(Logger.self).lifetime(.single)
builder.register{ MainLogger() }.asName("Main").asType(Logger.self).lifetime(.single)
```
В это примере создается 4 разных логгера, но все они доступны по одному типу `Logger`. Если убрать у них указание имен или сделать имена одинаковыми, то во время создания контейнера будет брошено исключение (см. [Создание контейнера](build.md)). Но в программе должен быть один логгер, но при этом при логгировании нужно вызывать метод логгирования для всех логгеров:
```Swift
let logger = try! container.resolve(Logger.self)
logger.log("msg") // должен вызваться метод для FileLogger(), ConsoleLogger(), OtherLogger()
```
Такая программа кинет исключение, так как не сможет понять, какой логгер от нее требуют. Для таких случаев есть понятие "по умолчанию" `asDefault`:
```Swift
builder.register{ FileLogger() }.asType(Logger.self).lifetime(.single)
builder.register{ ConsoleLogger() }.asType(Logger.self).lifetime(.single)
builder.register{ OtherLogger() }.asType(Logger.self).lifetime(.single)
builder.register{ MainLogger() }.asDefault().asType(Logger.self).lifetime(.single)
```
При таком объявлении, не броситься исключение как в прошлом примере, а создастся `MainLogger`, так как он отмечен "по умолчанию".

## Множественная
Но возникла другая проблема - теперь нельзя  получить доступ к другим логгерам. Как вариант можно вернуть имена, но обращаться по имени будет неудобно, так как для этого надо знать все имена. Для таких случаев есть возможность запросить все объекты по типу:
```Swift
let loggers: [Logger] = try! container.resolveMany(Logger.self)
// [FileLogger, ConsoleLogger, OtherLogger, MainLogger]
```
Теперь опираясь на эти знания, можно улучшить `MainLogger`:
```Swift
builder.register{ MainLogger(loggers: $0.resolveMany(Logger.self)) }.asDefault().asType(Logger.self).lifetime(.single)
```
Теперь` MainLogger` знает обо всех остальных логгерах. Обращаю также внимание, что из-за того что логгеры получаются внутри инициализации `MainLogger`, сам `MainLogger` не попадает в этот список. Но если получать логгеры внутри `dependency` или в любой другой части программы, то будут получены все логгеры, в том числе и `MainLogger`.

Более подробная информация описана в главе: [Регистрация с указанием имени/множественная регистрация](multi_name_registration.md)

## Передача параметров
Так как метод инициализации является подобием конструктора, а в конструкторе можно указывать параметры, то необходимость передавать параметры напрашивается сама собой:
```Swift
builder.register(Cat.self).initializer { _, name in Cat(name: name) }
...

let felix = container.resolve(Cat.self, arg: "felix")
let tiger = container.resolve(Cat.self, arg: "tiger")
```
Мы создали двух котов, и дали им клички. Обращаю внимание, что в отличие от `asName`, если мы пометим компонент как единственный в системе, то не зависимо от того какие будут передаваться аргументы, создастся он всего один раз:
```Swift
builder.register{ _, name in  Cat(name: name)}.lifetime(.single)
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
В случае если объект создает программа своими собственными силами, но этот объект всё равно имеет зависимости, то можно попросить библиотеку встроить зависимости в уже существующий объект. При этом не стоит забывать, что зарегистрировать компонент для типа этого объекта нужно в любом случае:
```Swift
builder.register{ Cat() }.dependency { scope, cat in cat.owner = try! scope.resolve()  }
...
let cat = Cat()
try! container.resolve(cat)
```
Также данная тема затрагивается в главе [Время жизни](lifetime.md)

## Сокращенный синтаксис
Писать каждый раз `try! ... resolve` неудобно, а в большинстве случаев тип известен заранее и у компоненты не задано имя. Для таких случаев существует специальные укороченные записи:
```Swift
cat = try *container //cat = try container.resolve()
cat = *!container //cat = try! container.resolve()
cat = *?container //cat = try? container.resolve()
cats = try **container //cats = try container.resolveMany()
cats = **!container //cats = try! container.resolveMany()
```
Эта запись, похоже на вариант оператора разыменовывания, и имеет 5 вариантов: `*` `*!` `*?` `**` `**!`

## Проверки и исключения
Читатель, наверное, обратил внимание, что везде используется `try`. Библиотека отсекла часть ошибок на стадии создания контейнера, но она не способна предугадать, как её будут использовать дальше. 
Во время разрешения зависимостей возможны следующие ошибки:
* Нет компонента по указанному типу.
> Ошибка: **`DIError.typeIsNotFound(type:)`**  
> Параметры:  
>            type - тип, для которого не удалось найти компонент
***

* Нет компонента по указанному типу и имени.
> Ошибка: **`DIError.typeIsNotFoundForName(type:,name:,components:)`**  
> Параметры:  
>            type - тип, для которого не удалось найти компонент с указанным именем  
>            name - имя, для которого не удалось найти компонент  
>            components: компоненты, которые были найдены для данного типа
***

* Нет метода инициализации с заданной сигнатурой для компоненты.
> Ошибка: **`DIError.initializationMethodWithSignatureIsNotFoundFor(component:,signature:)`**  
> Параметры:  
>            component - компонента, которая была выбрана для типа  
>            signature - сигнатура метода, которую не удалось найти
***

* Не указана компонента по умолчанию.
> Ошибка: **`DIError.defaultTypeIsNotSpecified(type:,components:)`**  
> Параметры:  
>            type - тип, для которого не указана компонента по умолчанию  
>            components - все компоненты для этого типа
***

* Рекурсивная инициализация объекта.
> Ошибка: **`DIError.recursiveInitialization(component:)`**  
> Параметры:  
>            component - компонент, который содержит рекурсивную инициализацию  
***

* Созданный объект, не соответсвует запрашиваемому типу (см. примечания в [Создание контейнера](build.md))
> Ошибка: **`DIError.typeIsIncorrect(requestedType:, realType:, component:)`**  
> Параметры:  
>            requestedType - запрашиваемый тип  
>            realType - тип объекта, который был создан  
>            component – компонент, используемый для создания типа
***

#### [Главная](main.md)
#### [Предыдущая глава "Создание контейнера"](build.md)
#### [Следующая глава "Указанием имени/множественная регистрация"](multi_name_registration.md)
