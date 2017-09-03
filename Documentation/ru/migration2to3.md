# Миграция с версии 2.x.x на версию 3.x.x
Перед миграцией взвесте все за и против, так-как изменения достаточно колосальные. При этом новый более лаконичный синтаксис с улучшенными проверками возможно вам и не нужны. Основная особенность этого обновления, что API в дальнейшем не будет претерпивать серьезных изменений, будут добавляться новые возможности, но старые изменяться не будут.

Если приведенные ниже возможности не являются для вас критичными, и проект не планируется развиваться еще очень долго, то не стоит проводить миграцию. Но миграцию стоит провести если вы планируете использовать swift4 и выше, так как версии 2.x.x не будут переходить на 4 версию языка. А вот версия 3.x.x разделена: 3.0.x - для swift3, а 3.x.x для 4, где второй x больше 0.


## Описание изменений
Благодаря этому обновлению стала возможным сделать отрисовку графа зависимостей вашего приложения. На текущий момент весь граф хранится только в памяти, но после перехода на swift4 все силы будут направлены на отдельный проект и добавление функционала, для сохранения и визуализации графа зависимостей.

В силу написанных ниже изменений, стало не удобно использовать регистрацию/получение по имени, но при этом теги стали неотъемлимой частью библиотеки. У тегов есть преимущество - сложнее допустить опечатку, но и минус - этот тип в приложении, а значит к этому типу должны иметь доступ в разных местах системы.

### DIComponentBuilder + DIComponent = DIComponent
* Произошло слияние DIComponent и DIComponentBuilder. Теперь для регистрации и для получения объекта используется один и тотже объект. Сделано это в рамках упрощения синтаксиса, а также ускорения работы библиотеки. Но в отличии от других библиотек эти действия не защищены от многопоточности. Одновременная регистрация и получение объекта может послужить причиной падения приложения. Также это слияние дает возможность во время исполнения легко подключать дополнительный код.
* Функция `build` удалена. Но это не значит, что вы оставлены самим себе. Теперь появилась более сильная функция `valid` - она проверяет валидность графа связей. Эта функция может гарантировать отсутствие падений во время исполнения из-за некорректных регистраций. Но так как эта проверка основана на валидации графа, она не может гарантировать, что вызовы функции resolve из вашего кода пройдут успешно.
* Функция `register` стала более простой. теперь не надо писать `type:`. Как и раньше функция на вход принимает или Тип или Метод инициализации.
* `resolve` сильно упрощен - он теперь всегда возвращает тот тип который вы от него требуете. Если типа не будет найдено, то программа упадет. Но не бойтесь - опционалы теперь работают на полную мощность. Не надо больше писать try? или какойто особый синтаксис, все делается автоматически. НО! было принято решение что ImplicitlyUnwrappedOptional не является опционалом - если этого типа нет, то программа также упадет.
* Остался всего один сокращенный синтаксис: `*container` который автоматически делает `resolve`.
* В силу чего появились два вспомагательных метода: `by(tag:on:)` и `many(:)`. Для получения объекта по имени придется как и раньше вызвать функцию `resolve(name:)`

### DIComponentBuilder
* Удалилось разделение указание типа, имени, тега. Теперь это одна функция, которая принимает на вход: тип, тип+имя, тип+тег. Причина: На старом синтаксисе было не понятно, как связываются теги, имена и типы между собой. Теперь это явно очевидно.
* Убрано обязательное условие на использование `check` у оператора `as`. Но я настоятельно рекомендую его использовать, чтобы обезопасить себя.
* `setDefault()` переименован в `default()`
* Убраны методы: `initial`. В этом месте произошло понижение возможностей - теперь можно указать только один метод инициализации, и он указывается при вызове функции `register`. Это позволило сократить избыточность синтаксиса, и сделать его более кратким, правда в обмен на одну мало нужную возможность.
* Убрана возможность передачи runtime аргументов. Эта возможность мало используемая, но при этом очень не продуманная: например мне нужно передать аргументы через 3 инициализации в DI, что становится невозможным. Проблема с мульти инициализацией и передачи аргументов будет решена в дальнейшем не стандартным решением.
* Убраны все `.manual` и `.optional` методы. Для построения графа эти методы неприемлимы, поэтому они были убраны. Все для чего раньше надо было применять метод с `.manual` теперь можно решить штатными средствами. Единственное исключение - инициализации которым нужны именованные параметры.
* У функии `injection` для внедрения зависимости по параметру, появился булев флаг: `injection(cycle:)`. Старая реализация позволяющая работать с циклами имела ряд недостатков, которые были устранены в новой версии. Но при этом стало необходимо явно указывать места где возможны циклы. В принципе функция `valid()` не пройдет если будут циклы которые невозможно создать, и напишет ошибку в логи - какие именно циклы надо "разорвать". Разрыв цикла - это указание у этой функции `true`, то есть: `injection(cycle: true) { $0.property = $1 }`. Как видно библиотека способна сама находить места где стоит поставить данное значение, но не делает это в угоду скорости работы. 


### DIComponent/DIModule -> DIPart/DIFramework 
* `DIComponent` переименован в `DIPart`. Так как компонент является именем используемым в других DI для обозначения другой сущности. Более того новое название лучше отображает его предназначение - это объединение компонентов в одну сущность, то есть это какая-то "часть" системы.
* `DIModule` переименова в `DIFramework`. Библиотека написана для apple систем, не стоит отклоняться от ихнего способа именования.
* Синтаксис объявления `DIFramework` перестал отличаться от `DIPart`. То есть это два протокола отличающихся лишь название и предназночением.
* `DIFramework` и `DIPart` теперь имеют статическую функцию `load(container:)`. Соответственно регистрируются теперь не экземпляры этих классов, а сами классы.
* Функция `register` разделена. Теперь через эту функции возможно зарегестрировать только новый тип. Чтобы добавить в контейнер `DIFramework` или `DIPart` появились две функции: `append(part:)` и `append(framework:)`
* Полностью удалена область видимости у `DIPart`. Библиотека теперь сама ищет нужный компонет. При поиске учитывается начилие `default` у компоненты и ее иеархичное разменение в bundle.
* Для задания иеархии между frameworks появилась функция `import`. Эта функция действует по аналогии дерективы swift import - она лишь говорит где можно искать реализации. Использовать эту функцию стоит только внутри реализации `DIFramework`, в противном случае библиотека не гарантирует валидность. 

### DIError/DILog
* Полностью убраны ошибки. Теперь все ошибки/предупреждения и информация попадают в логи.
* Логгер стал важной частью системы - если чтото работает не как планировалось, в первую очередь стоит заглянуть в логгер особенно на ошибки с уровнем error и warning.
* Логгирование стало иеархическим. То есть в логах появилась табуляция, которую при желании можно отключить.
* Убран протокол для логирования. Теперь для этих целей можно задать функцию.
* Изменены уровни логирования на: `error`, `warning`, `info`, `none`. И стало возможность фильтровать логи по уровню.

### DIStoryboard
* Убраны отдельные функции для регистрации ViewController - теперь они регистрируются также как и обычные типы
* Создание `DIStoryboard` теперь происходит с помощью статической функции `create(name:bundle:)` или `create(name:bundle:container:)`
* Но стоит регистрировать storyboard отдельной функцией: `registerStoryboard(name:bundle:)` - это упрощает дальнейшую работу и!
* Появилась поддержка storyboardReference. Но сторибоарды на которые ведут ссылки обязаны быть зарегестрированы с помощью функции `registerStoryboard(name:bundle:)`

### DIScan
Так как `DIFramework` и `DIPart` теперь являются классами которые не надо инициализировать, то из-за этого был переработан синтаксис сканирования:
* Теперь для этого придется создавать целый класс. Безусловно синтаксически это стало менее красиво, но зато быстрее с точки зрения исполнения.
* Внутри класса можно переопределить predicate или bundle. При этом для `DIScanFramework` bundle указать нельзя, в силу его ненужности.
* Предикаты также как и раньше остались двух видов: по имени и по типу. При этом если его не переопределить или сделать nil, то будут выданы все фреймворки/части.
* `DIScanned` остался без изменений и несет тотже смысл.
* Если в вашем коде возможна динамическая подрузка кода во время исполнения, то вам может понадобится функция: `DIScan.resetCache()`. Для ускорения работы сканирования все классы единожды кэшируются, и не происходит сканирование всего проекта. Так как код появляется позже, и кэш скорей всего уже создан, то его надо удалить чтобы при следующем обращение он создался заново.

### DILifeTime
* Убран perScope в силу его ненужности.
* `perDependency` разделен на два: `prototype` и `objectGraph`.
* `prototype` - не зависимо ни от чего объект будет создаваться всегда новый.
* `objectGraph` - объект также всегда создается новый, но единожды в рамках одного разрешения зависимостей. Это время жизни стоит указывать в случае циклов, на те объект с которых будет начинаться цикл. В случае если у вас есть цикл состоящий из объектов с разными временами жизни, и есть хотябы один объект с `objectGraph`, то будет написано всеголишь предупреждение, что возможны проблемы.

### Cocoapods
* Теперь вся библиотека идет целиком - нету деления на части. Это позволило сократить код, и улучшить производительность

## Примеры изменений синтаксиса
Дальше будут примеры как было раньше и как стало:

### Общий вид
БЫЛО:
```
let builder = DIContainerBuilder()
builder.register(type: YourType.self)
  .initial(YourType.init)
  .injection{ $0.parameter = $1 }

builder.register(module: YourModule())
builder.register(component: YourComponent())

let container = try! builder.build()
```
СТАЛО:
```
let container = DIContainer()
builder.register(YourType.init)
  .injection{ $0.parameter = $1 }

container.append(framework: YourFramework.self)
container.append(part: YourPart.self)

if !container.valid() { // можно проверять только в дебаге, а в релизе упустить для экономии времени загрузки 
  fatalError("Your write incorrect dependencies graph")  
}
```

### Компонент без метода инициализации

БЫЛО:
```
builder.register(type: YourType.self)
.initialNotNecessary()

builder.register(vc: YourViewControllerType.self)
```
СТАЛО:
```
container.register(YourType.self)

container.register(YourViewControllerType.self)
```

### Множественная и по тегу

БЫЛО:
```
builder.register(type: YourType.self)
  .initial{ YourType(pTag: $0.resolve(tag: yourTag), pMany: $0.resolveMany()) }
  .injection(.manual) { $1.parameterTag = $0.resolve(tag: yourTag) }
  .injection(.manual) { $1.parameterMany = $0.resolveMany() }

```
СТАЛО:
```
container.register{ YourType(pTag: by(tag: YourTag.self, on: $0), pMany: many($1)) }
  .injection { $0.parameterTag = by(tag: YourTag.self, on: $1) }
  .injection { $0.parameterMany = many($1) }
```

### По имени

БЫЛО:
```
builder.register(type: YourType.self)
  .initial{ YourType(pName: $0.resolve(name: "yourName")) }

builder.register(type: YourTypeParameter.self)
  .injection(.manual) { $1.parameterName = $0.resolve(name: "YourName") }

```
СТАЛО:
```
// Регистрация с указанием имени в методе инициализации не поддерживаем. Но есть Теги.

container.register(YourTypeParameter.self)
  .injection(name: "YourName") { $0.parameterName = $1 }
```

### Опционалы

БЫЛО:
```
builder.register(type: YourType.self)
  .initial{ YourType(pOptional: try? $0.resolve()) }
  .injection(.optional) { $0.parameterOpt = $1 }

builder.register(type: YourType2.self)
  .initial{ YourType(pOptional: try? $0.resolve()) }
  .injection(.manual) { $1.parameterOpt = try? $0.resolver() }

```
СТАЛО:
```
container.register(YourType.init)
  .injection { $0.parameterOpt = $1 }

container.register{ YourType2(pOptional: $0) }
  .injection { $0.parameterOpt = $1 }
```

### Указание альтернативного имени

БЫЛО:
```
builder.register(type: YourType.self)
  .as(YourProtocol.self).unsafe()
  .as(YourProtocol.self).check{$0}
  .as(YourPorotocl.self){$0}

```
СТАЛО:
```
container.register(YourType.self)
  .as(YourProtocol.self)
  .as(check: YourProtocol.self){$0}
```

### Указание имени или тега

БЫЛО:
```
builder.register(type: YourType.self)
  .as(YourProtocol.self)
  .as(YourProtocol2.self)
  .set(name: "YourName")
  .set(tag: yourTag)
  // Данный синтаксис генерировал все возможные варианты, то есть: YourProtocol+"YourName", YourProtocol+yourTag, YourProtocol2+"YourName", YourProtocol2+yourTag
  // В большинстве случае это не совсем то чего хочется, поэтому синтаксис был переделан, на более однозначный
```
СТАЛО:
```
container.register(YourType.self)
  .as(YourProtocol.self, name: "YourName")
  .as(YourProtocol2.self, tag: YourTag.self)
  // тут мы явно написали две пары, хотя можем написать еще пару строчек, и создать еще варианты, но скорей всего этого не требуется.
```

### DIComponent/DIModule = DIPart/DIFramework

БЫЛО:
```
class YourComponent: DIComponent {
  func load(builder: DIContainerBuilder) { ... }
}

class YourModule: DIModule {
  var components: [DIComponent] = { return [ YourComponent() ] }
  var dependencies: [DIModule] = { return [YourOtherModule() ] }
}
```
СТАЛО:
```
class YourPart: DIPart {
  static func load(container: DIContainer) { ... }
}

class YourFramework: DIFramework {
  static func load(container: DIContainer) {
    container.append(part: YourPart.self)
    container.append(framework: YourOtherFramework.self) // возможно эта строчка и не нужна - достаточно чтобы ктото один раз прикрепил загрузку framework
    container.import(YourOtherFramework.self) 
  }
}
```

### Цикл

БЫЛО:
```
builder.register(A.init(b:))

builder.register(B.init)
  .injection{ $0.a = $1 }
```
СТАЛО:
```
builder.register(A.init(b:))
  .lifeTime(.objectGraph)

builder.register(B.init)
  .injection(cycle: true) { $0.a = $1 }
  .lifeTime(.objectGraph)
```
Усложнение синтаксиса было сделано из-за ускорения работы библиотеки.

### Сканирование
БЫЛО:
```
builder.register(component: DIScanComponent(predicateByName: { $0.contains("component") }, in: Bundle(for: YourClass.self)))
```
СТАЛО:
```
class YourScanPart: DIScanPart {
  override class var predicate: Predicate? { return .name({ $0.contains("part") }) }
  override class var bundle: Bundle? { return Bundle(for: YourClass.self) }
}
container.append(part: YourScanPart.self)
```

### Получение объектов
БЫЛО:
```
let obj1: Obj1Type = try! container.resolver()
let obj1Opt: Obj1Type? = try? container.resolver()

let obj2: Obj2Type = *container
let obj2Opt: Obj2Type? = *?container

let obj3: Obj3Type = try! container.resolve(tag: yourTag)
let obj4: Obj4Type = try! container.resolve(name: "name")
let objs: [ObjType] = try! container.resolveMany()
```
СТАЛО:
```
let obj1: Obj1Type = container.resolver()
let obj1Opt: Obj1Type? = container.resolver()

let obj2: Obj2Type = *container
let obj2Opt: Obj2Type? = *container

let obj3: Obj3Type = container.resolve(tag: YourTag.self) // by(tag: YourTag.self, on: *container)
let obj4: Obj4Type = container.resolve(name: "name")
let objs: [ObjType] = container.resolveMany() // many(*container)
```

## Что дальше?
Более подробно об новом синтаксисе и возможностях можно почитать в [документации](main.md).

Чтобы установить и начать использовать новую версию, обновите библиотеку до версии выше или равной 3.0.0.
