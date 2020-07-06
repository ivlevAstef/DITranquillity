# Внедрение в subview и ячейки
Можно внедрять зависимости в subviews и ячейки UITableView или элементы UICollectionView. 

В целях производительности, внедрение зависимостей по умолчанию отключено, чтобы им воспользоваться необходимо при регистрации контроллера явно указать наличие внедрения, вызвав функцию `autoInjectToSubviews`:
```Swift
container.register(YourTableViewCell.self)
  .injection { cell, inject in cell.inject = inject }

container.register(YourView.self)
  .injection { view, inject in view.inject = inject }

container.register(YourViewController.self)
  .injection { vc, inject in vc.inject = inject }
  .autoInjectToSubviews() // Включает внедрение в дочерние view.


class YourViewController {
  @IBOutlet var myView: YourView!
  @IBOutlet var tableView: UITableView!
}
```

Помимо этого можно настроить автоматическое внедрение глобально (*Не рекомендуется*) с помощью `DISetting`:
```Swift
DISetting.Defaults.injectToSubviews = true
```
После данной настройки нет необходимости включать внедрение в subviews для каждого контроллера в отдельности.

> Внимание. Данный функционал замедляет скорость работы приложения.
> При грамотной архитектуре подобный функционал не нужен, так как во view должны приходить ViewModel-и и сама view-а не должна ничего грузить самостоятельно.

