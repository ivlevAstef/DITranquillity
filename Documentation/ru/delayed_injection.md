# Отложенное внедрение

В некоторых случаях необходимо чтобы объекты создавались не сразуже при внедрении зависимости, а только тогда, когда они необходимы.
DITranquillity для этого интегрирован с библиотекой SwiftLazy которая предоставляет два способа отложенной инициализации: Lazy и Provider.

* Lazy - ведет себя аналогично тому как это сделана у Swift: объект создается при первом обращении и запоминается
* Provider - объект создается при каждом обращении.

Замечание: Эти механизмы никак не связаны с временем жизни - они лежат поверх всего этого.

Отличие между Lazy, Provider и обычным внедрением лучше всего можно продемонстрировать на примере внедрения Int:
```
var counter: Int = 0
container.register { () -> Int in
  counter += 1
  print("creating int")
  return counter
}
```

## Обычное внедрение
```
class DirectInjection {
  let value: Int

  func test()
  {
    print("begin")
    print(value)
    print(value)
    print(value)
  }
}

let container = DIContainer()

container.register(DirectInjection.init)

let injection: DirectInjection = *container
injection.test()
```
Этот пример выведет:
```
creating int
begin
1
1
1
```

## Lazy
```
class LazyInjection {
  let value: Lazy<Int>

  func test()
  {
    print("begin")
    print(value)
    print(value)
    print(value)
  }
}

let container = DIContainer()

container.register(LazyInjection.init)

let injection: LazyInjection = *container
injection.test()
```
Этот пример выведет:
```
begin
creating int
1
1
1
```

## Provider
```
class ProviderInjection {
  let value: Provider<Int>

  func test()
  {
  print("begin")
  print(value)
  print(value)
  print(value)
  }
}

let container = DIContainer()

container.register(ProviderInjection.init)

let injection: ProviderInjection = *container
injection.test()
```
Этот пример выведет:
```
begin
creating int
1
creating int
2
creating int
3
```

#### [Главная](main.md)
#### [Предыдущая глава "Storyboard"](storyboard.md#storyboard)
#### [Следующая глава "Логирование"](log.md#Логирование)


