//
//  RootCoordinator.swift
//  TimeLearner Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol RootCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol RootCoordinatorInput {

  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: RootCoordinatorOutput? { get set }
}

typealias RootCoordinatorProtocol = RootCoordinatorInput & Coordinator

final class RootCoordinator: RootCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: RootCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let window: UIWindow
  private let navigationController = UINavigationController()
  private var mainScreenCoordinator: MainScreenCoordinatorProtocol?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - window: Окно просмотра
  ///   - services: Сервисы приложения
  init(_ window: UIWindow) {
    self.window = window
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainScreenCoordinator = MainScreenCoordinator(window,
                                                      navigationController)
    self.mainScreenCoordinator = mainScreenCoordinator
    mainScreenCoordinator.start()
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
}
