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

### Описание логов
#### error логи



± * `You have a cycle: ... consisting entirely of initialization methods. Full: ...` Возникает при валидации графа. Говорит что есть цикл состоящий только из методов инициализации - то есть при получении любого объекта из указанного цикла программа упадет из-за бесконечной инициализации. В логах вначале указывает какие типы участвуют в цикле, а потом полную информацию о этих типах. Для решения проблемы надо разорвать цикл отказавшись где-то от внедрения через метод инициализации. Подробно про разрыв циклов тут: [внедрение](injection.md#Внедрение-через-свойства)
± * `Cycle has no discontinuities. Please install at least one explosion in the cycle: ... using injection(cycle: true) { ... }. Full: ...` Аналог предыдущей ошибки, но тут цикл состоит не только из методов инициализации, но в нем участвует другой способ внедрения. Способ решения эквивалентен предыдущему.
± * `You cycle: ... consists only of object with lifetime - prototype. Please change at least one object lifetime to another. Full: ...`  Указанный цикл состоит только из `prototype` объектов. Это также приведет к бесконечному созданию, так как каждый объект будет создаваться всегда заново. Для решения проблемы нужно хотя бы один объект пометить как `objectGraph`, и желательно тот, с которого будет начинаться получение. Подробно про время жизни тут: [Время жизни](scope_and_lifetime.md)

#### error/warning логи

В зависимости от того является ли тип опциональным или нет в логах может быть как ошибка так и варнинг.
± * `Not found component for {type} from {Component}` - Не зарегистрирован указанный тип в контейнере, но его пытаются получить из указанного компонента. Для решение проблемы убедитесь, что указанный тип регистрируется в DI контейнере или уберите его получение из компонента.
± * `Not found component for {type} from {Component} that would have initialization methods. Were found: {Components}"` - для указанного типа есть зарегистрированные компоненты (указаны в конце), но не у одного из них нет метода инициализировать. При этом этот тип нужен другому компоненту, и его точно нужно иницилазировать. Чаще всего проблема возникает, если у указанных компонентов в конце во время регистрации был написан `.self` а не `.init`:  `container.register(Type.self)`
± * `Ambiguous {type} from {Component} contains in: {Components}` - Слишком большой выбор. Для указанного типа есть несколько регистраций/компонентов и библиотека не способна определить какой из них выбрать. Нужно или добавить `default` или уточнить с помощью имени или тэга, или воспользоваться модульностью. 

#### info логи
± * `Not found component for {type} from {Component} that would have initialization methods, but object can maked from cache. Were found: {Components}"` - похожа на вторую ошибку из предыдущей секции, но есть одно важное отличие - в некоторых ситуациях этот компонент мог быть получен раньше, и его получится взять иэ кэша.
± * `"You cycle: ... contains an object with lifetime - prototype. In some cases this can lead to an udesirable effect.  Full: ...` - Цикл содержит объекты с временем жизни `prototype`. В зависимости от того с какого объекта начинается создание цикла поведение создания объектов может отличаться, что обычно не очень хорошо. Советую проверить точно ли в этом цикле нужны объекты с временем жизни `prototype`