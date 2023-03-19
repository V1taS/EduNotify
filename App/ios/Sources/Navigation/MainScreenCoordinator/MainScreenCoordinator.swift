//
//  MainScreenCoordinator.swift
//  TimeLearner Files
//
//  Created by Vitalii Sosin on 12.03.2023.
//

import UIKit
import PhotosUI
import MainScreenModule
import YandexMobileMetrica
import Notifications
import FileManagerService
import PermissionService
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: MainScreenCoordinatorOutput? { get set }
}

typealias MainScreenCoordinatorProtocol = MainScreenCoordinatorInput & Coordinator

final class MainScreenCoordinator: NSObject, MainScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: MainScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainScreenModule: MainModuleInput?
  private var anyCoordinator: Coordinator?
  private let window: UIWindow?
  private let fileManagerService = FileManagerImpl()
  private let permissionService = PermissionServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - window: Окно просмотра
  ///   - navigationController: UINavigationController
  init(_ window: UIWindow?,
       _ navigationController: UINavigationController) {
    self.window = window
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainScreenModule = MainScreenAssembly().createModule()
    self.mainScreenModule = mainScreenModule
    self.mainScreenModule?.moduleOutput = self
    
    checkDarkMode()
    navigationController.pushViewController(mainScreenModule, animated: true)
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func checkDarkMode() {
    let isDarkTheme = UserDefaults.standard.bool(forKey: Appearance().isDarkThemeKey)
    guard let window else {
      return
    }
    window.overrideUserInterfaceStyle = isDarkTheme ? .dark : .light
  }
}

// MARK: - Private

private extension MainScreenCoordinator {
  func showNegativeAlertWith(title: String,
                             glyph: Bool,
                             timeout: Double?,
                             active: (() -> Void)?) {
    let appearance = Appearance()
    
    Notifications().showAlertWith(
      model: NotificationsModel(
        text: title,
        textColor: .black,
        style: .negative(colorGlyph: .black),
        timeout: timeout ?? appearance.timeout,
        glyph: glyph,
        throttleDelay: appearance.throttleDelay,
        action: active
      )
    )
  }
}

// MARK: - MetricsnEvents

private extension MainScreenCoordinator {
  enum MetricsnEvents: String {
    case addTimeLearner
  }
}

// MARK: - Appearance

private extension MainScreenCoordinator {
  struct Appearance {
    let isDarkThemeKey = "isDarkThemeKey"
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
    
    let timeout: Double = 2
    let throttleDelay: Double = 0.5
    let systemFontSize: CGFloat = 44
  }
}
