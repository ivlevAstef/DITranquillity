# Примеры

## Chaos
##### [Ссылка](https://github.com/ivlevAstef/DITranquillity/tree/master/Samples/SampleChaos)

Пример представляет из себя солянку из всего. 
Он использовался во время создания проекта для проверки нового функционала.
Я решил оставить его, так как полезную информацию из него можно получить.

## Delegate and Observer
##### [Ссылка](https://github.com/ivlevAstef/DITranquillity/tree/master/Samples/SampleDelegateAndObserver)

Проект показывает возможность подписать ViewController на делегат у другого ViewController-а, причем сами ViewController-ы остаются независимыми - они ничего не знаю о существовании друг друга.

Также в нем есть пример близкого паттерна - наблюдатель. В отличие от делегата, наблюдателей может быть много, поэтому создается несколько ViewController-ов которые являются наблюдателями и есть один ViewController, который оповещает наблюдателей об изменении себя. Также как и с делегатом сами ViewController-ы остаются не зависимыми.

## Habr
##### [Ссылка](https://github.com/ivlevAstef/DITranquillity/tree/master/Samples/SampleHabr)
Это маленький пример проекта, содержащий работу с сетью и связывающий такие уровни как: Data, Presenter, ViewController, Utils. Содержит внутри себя логгер, который является другим проектом.

## OSX
##### [Ссылка](https://github.com/ivlevAstef/DITranquillity/tree/master/Samples/SampleOSX)
Пример проекта под OSX

## Сравнение со swinject
##### [Ссылка](https://github.com/ivlevAstef/DITranquillity/tree/master/Samples/CompareSpeedSwinjectVSTranquillity)
Проект предназначенный для сравнения скорости работы на приближенных к реальным данным. Имеет около 15 основных классов, и 128 дополнительных сгенерированных классов, для нагрузки.
Проект показал, что время работы tranquillity на 15% быстрее swinject в случае с 15 классами, и более чем в два раза быстрее в случае если используется около 140 классов.

## Big Project
Тестовый проект находится в планах. Но на текущий момент библиотека успешно работает в рамках проекта с кодовой базой порядка 200к строк кода.


#### [Главная](main.md)
