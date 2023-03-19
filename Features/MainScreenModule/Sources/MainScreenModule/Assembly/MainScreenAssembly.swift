//
//  MainScreenAssembly.swift
//  MainScreenModule
//
//  Created by Vitalii Sosin on 19.03.2023.
//

import UIKit

/// Сборщик `MainScreen`
public final class MainScreenAssembly {
  public init() {}
  
  /// Собирает модуль `MainScreen`
  /// - Returns: Cобранный модуль `MainScreen`
  public func createModule() -> MainModuleInput {
    let interactor = MainScreenInteractor()
    let view = MainScreenView()
    let factory = MainScreenFactory()
    let presenter = MainScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
