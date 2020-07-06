# Валидация графа
Одной из особенностей библиотеки является возможность построения графа зависимостей после регистрации компонентов. 

На основе этой возможности библиотека предлагает проверить этот граф, до начала использования. То есть регистрируем все зависимости, [получаем граф](get_graph.md), вызываем функцию валидации - а она проверяет, что все зарегистрировано верно. 

Эта функция называется `checkIsValid` и находится в контейнере:
```Swift
container.register(...)
container.register(...)
...

#if DEBUG
if !container.makeGraph().checkIsValid(checkGraphCycles: true) {
    fatalError("invalid graph")
}
#endif
```
Подобная валидация не имеет смысла в релизной версии, так как граф зависимостей не меняется от запуска к запуску. Поэтому для экономия времени советую функцию валидации заносить в predefine секцию.

Функция проверяет граф на: достижимость вершин, однозначность переходов, возможность создать объект. Булева переменная `checkGraphCycles` добавляет проверку циклов. 

Все возникшие проблемы пишутся в лог, и если возникла критическая проблема, то функция проверки вернет `false`. О том что такое логирование можно почитать [тут](logs.md) А ниже описаны все возможные ошибки которые могут возникнуть во время проверки графа.

## Описание логов
### Логи связанные с инициализацией компонента
* `No initialization method for {Component}. And found reference on this component from {FromComponent}.` - подобная ошибка возникает в случае если нет метода инициализации у указанного компонента. Но при этом по графу зависимостей этот метод обязан быть, так как на объект есть переход, и он точно не может появится из неоткуда. В случае если зависимость опциональная, то это будет не ошибкой, а предупреждением.
* `No initialization method for {Component}. This component can be created using 'inject(into:...' or if created from storyboard. Otherwise it's incorrect. And found refrence on this component from {FromComponent}.` - предупреждение похоже на предыдущую ошибку, но в отличии от прошлой тут объект может быть создан, если это VC на storyboard или же вызывается функция `inject(into:`.
* `No initialization method for {Component}. This component can be created using 'inject(into:...' or if created from storyboard. After first created component can be taken from cache. And found refrence on this component from {FromComponent}.` - инфо сообщение о том, что могут быть проблемы при создании компонента, но существует много случаев когда он создасться нормально, из-за того, что объект будет закэширован.
* `No initialization method for {Component}. This component can be created using 'inject(into:...' or if created from storyboard. Otherwise it's incorrect.` - инфо сообщение о том что нет метода инициализации. Но при этом на этот компонент никто не ссылает. Такой компонент нельзя создавать функцией `resolve` но он создасться в случае если это VC, или с помощью метода `inject(into:`
* `No initialization method for {Component}. This component can be created using 'inject(into:...' or if created from storyboard. After first created component can be taken from cache.` - инфо сообщение аналог предыдущему, но по мимо этого после первого создания компонент будет закэширован. Его можно будет в дальнейшем получать обычным образом.

###  Логи связанные с неоднозначным внедрением
* `Ambiguity create object for type: {Type} into {Component}. Candidates: {Candidates}` - ошибка или предупреждение в зависимости от того является ли тип опционалом. Ошибка говорит о том что в указанном компоненте есть зависимость требующая указанного типа, но эту зависимость создать не удастся, так как есть несколько компонентов подходящих для внедрения. В случае подобной ошибки надо или убрать лишний компонент, или с помощью тэгов, имени, модульности добиться однозначности.  

### Логи связанные с неверным внедрением
* `Invalid reference from {FromComponent} because not found component for type: {Type}` - Ошибка, если тип не опционал или не множественное внедрение, иначе предупреждение. Говорит о том что из указанного компонент есть внедрение которое не удастся внедрить, так как для него не зарегестрирован компонент. Чаще всего данная ошибка возникает из-за невнимательности когда пишешь новый код - забываешь дописать регистрацию для чего либо.

### Логи связанные с циклами
* `Found a cycle used only init methods. Please tear cycle: {CycleDescription}` - ошибка. Указанный цикл состоит только из методов инициализации. Подобный цикл будет создаваться бесконечно. Для решения проблемы надо разорвать цикл хотябы в одном месте - перенести внедрение из метода инициализации в свойства.

* `Found a cycle without tears. Please tear cycle use '.injection(cycle: true...': {CycleDescription}` - ошибка. Указанный цикл не имеет указаний точек разрыва. Для устранению проблемы стоит исправить хотябы одно внедрение указав `cycle: true`. Тем самым дав понять библиотеке, что вы согластны с этим циклом и контролируете ситуацию.

* `Found a cycle where any components have lifetime 'prototype'. This cycle will be created indefinitely. Please change lifetime on 'objectGraph' or other. Cycle description: {CycleDescription}` - ошибка. Указанный цикл состоит только из компонентов с временем жизни `prototype`. Обычно для всех объектов в цикле нужно использовать время жизни `objectGraph` или время жизни с кэшом, но обязательно хотябы для одного. В случае же с `prototype` объекты будут создаваться бесконечно. Для решения проблемы поменяйте время жизни хотябы у одного компонента из цикла, а лучше у всех.

* `Found a cycle where is it components have lifetime 'prototype'. This cycle can maked incorrect, if call resolve from 'prototype' component. Your can change lifetime on 'objectGraph' or ignore warning. Cycle description: {CycleDescription}` - предупреждение. Аналог предыдущей проблемы, но в данном случае есть время жизни отличное от `prototype`. Для того чтобы понять есть ли ошибка, нужно осоздать с какого объекта начинается создание объектов - если с `prototype` то это приведет к нежелаемому результату. 

* `Found a cycle where is it components have different lifetimes. This cycle can maked incorrect. If start resolve from 'prototype'/'objectGraph' you can reference from 'perContainer'/'perRun'/'single' on other object because there is an old resolve in cache. Cycle description: {CycleDescription}` - предупреждение. В указанном цикле используются разные время жизни, в том числе и кэширующие. Такой цикл может приводить к нежелаемому поведению в случае если создание объекта начинается не с кэширующего времени жизни. Проблема в том, что после первого создания ссылки из закэшируемых объектов уже будут созданы и не обновятся если вы повторно запросите объект не из кэша.
