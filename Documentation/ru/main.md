# Описание
DITranquallity - небольшая библиотека для внедрения зависимостей в приложениях, написанных на чистом Swift. Несмотря на её размер, она решает достаточно большой спектр задач, в том числе поддерживает Storyboard. Главное её преимущество над остальными - поддержка модульности, подробное логирование и валидация графа зависимостей.

# Особенности

* Поддержка чистых Swift типов
* Внедрение зависимостей через: [метод инициализации](registration.md#Разрешение-зависимостей-при-инициализации), [свойства, метод](injection.md#Внедрение)
* [Указание тега](modificators.md#Теги), [имени](modificators.md#Имена) и получение [множества](modificators.md#Множественная)
* [Поддержка указания нескольких сервисов](registration.md#Указание-сервисов)
* [5 времен жизни: single, perRun(.weak/.strong), perContainer(.weak/.strong), objectGraph, prototype](lifetime.md#Время-жизни)
* [iOS/macOS Storyboard и StoryboardReference](storyboard.md#storyboard)
* [Поддержка циклических зависимостей](injection.md#Внедрение-циклических-зависимостей-через-свойства)
* Несколько уровней абстракций: тип, [часть](part_framework.md#Части-и-Фреймворки), [фреймворк](part_framework.md#Части-и-Фреймворки)
* [Краткий синтаксис получения экземпляра клаcса](resolve.md#Разрешение-зависимостей)
* [Внедрение через свойства с помощью keyPath (начиная с swift 4.0)](injection.md#Внедрение-зависимостей-через-свойства-используя-keypath))
* [Поиск частей, фреймворков](scan.md#Поиск)
* [Логирование](log.md#Логирование)
* [Валидация графа зависимостей](validation.md#Валидация-контейнера)
* Потокобезопасный

# Главы

## [Быстрый старт](quick_start.md#Быстрый-старт)
* [Знакомство с идеей "инверсии зависимостей" и "внедрения зависимостей"](quick_start.md#Знакомство-с-идеей-инверсии-зависимостей-и-внедрения-зависимостей)
* [Добавление DITranquallity в ваш проект](quick_start.md#Добавление-ditranquillity-в-ваш-проект)
* [Регистрация](quick_start.md#Регистрация)
* [Разрешение зависимостей](quick_start.md#Разрешение-зависимостей)
* [Что дальше?](quick_start.md#Что-дальше)

## [Регистрация](registration.md#Регистрация)
* [Указание сервисов](registration.md#Указание-сервисов)
* [Разрешение зависимостей при инициализации](registration.md#Разрешение-зависимостей-при-инициализации)

## [Внедрение](injection.md#Внедрение)
* [Внедрение зависимостей через свойства](injection.md#Внедрение-зависимостей-через-свойства)
* [Внедрение циклических зависимостей через свойства](injection.md#Внедрение-циклических-зависимостей-через-свойства)
* [Внедрение зависимостей через свойства используя KeyPath](injection.md#Внедрение-зависимостей-через-свойства-используя-keypath)

## [Валидация контейнера](validation.md#Валидация-контейнера)
* [Синтаксис](validation.md#Синтаксис)
* [Что проверяется?](validation.md#Что-проверяется)

## [Разрешение зависимостей](resolve.md#Разрешение-зависимостей)
* [По тегу](resolve.md#По-тегу)
* [По имени](resolve.md#По-имени)
* [Множественная](resolve.md#Множественная)
* [По умолчанию](resolve.md#По-умолчанию)
* [Собираем все вместе](resolve.md#Собираем-все-вместе)
* [Внедрение](resolve.md#Внедрение)

## [Модификаторы](modificators.md#Модификаторы)
* [Теги](modificators.md#Теги)
* [Имена](modificators.md#Имена)
* [Множественная](modificators.md#Множественная)

## [Время жизни](lifetime.md#Время-жизни)
* [Одиночка (single)](lifetime.md#Одиночка-single)
* [Захват объекта (weak/strong)](lifetime.md#Захват-объекта-weakstrong)
* [Один на запуск (perRun)](lifetime.md#Один-на-запуск-perRun)
* [Один на контейнер (perContainer)](lifetime.md#Один-на-контейнер-perContainer)
* [Единственный в графе (objectGraph)](lifetime.md#Единственный-в-графе-objectgraph)
* [Всегда новый (prototype)](lifetime.md#Всегда-новый-prototype)

## [Части и Фреймворки](part_framework.md#Части-и-Фреймворки)
* [Объявление](part_framework.md#Объявление)
* [Регистрация](part_framework.md#Регистрация)
* [Импорт](part_framework.md#Импорт)

## [Storyboard](storyboard.md#storyboard)
* [Регистрация ViewController](storyboard.md#Регистрация-viewcontroller)
* [Создание Storyboard](storyboard.md#Создание-storyboard)
* [StoryboardReference](storyboard.md#Storyboardreference)
* [SubviewsInjection](storyboard.md#Subviews-injection)


## [Поиск](scan.md#Поиск)
* [Предыстория](scan.md#Предыстория)
* [Поиск фреймворков](scan.md#Поиск-фреймворков)
* [Поиск частей](scan.md#Поиск-частей)

## [Логирование](log.md#Логирование)
* [Использование](log.md#Использование)

## [Примеры](sample.md#Примеры)
* [Chaos](sample.md#chaos)
* [Delegate and Observer](sample.md#delegate-and-observer)
* [Habr](sample.md#habr)
* [OSX](sample.md#osx)
* [Сравнение со swinject](sample.md#сравнение-со-swinject)
* [~~Big Project~~](sample.md#big-project)

# [Словарик](glossary.md#Словарик)
