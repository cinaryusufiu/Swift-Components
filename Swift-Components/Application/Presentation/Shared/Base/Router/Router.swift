//
//  Router.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 28.05.2024.
//

import UIKit

protocol ModelTransferable {
    func describe() -> String
}

protocol DataReturnable {
    func prepareInjectData(_ data: ModelTransferable?)
}

protocol CompletionHandling {
    func setCompletionDataHandler(_ handler: @escaping (ModelTransferable) -> Void)
}

struct ExampleTransferedData: ModelTransferable {
    var content: String
    
    func describe() -> String {
        return "Transfered Data: \(content)"
    }
}

final class Router {
    
    //static let shared = Router()
    
    init() {}
    
    enum PresentationStyle {
        case push
        case present
        case presentWithPresentationStyle(modalStyle: UIModalPresentationStyle = .fullScreen,
                                          transitionStyle: UIModalTransitionStyle = .coverVertical)
        case presentWithoutNavigation(modalStyle: UIModalPresentationStyle = .fullScreen, 
                                      transitionStyle: UIModalTransitionStyle = .coverVertical)
    }
    
    func navigate<T: UIViewController>(to type: T.Type,
                                       presentationStyle: PresentationStyle = .present,
                                       animated: Bool = true,
                                       withTransferedData: ModelTransferable? = nil,
                                       withDataHandler dataHandler: ((ModelTransferable) -> Void)? = nil,
                                       completion: (() -> Void)? = nil) {
        let navigationController = UIApplication.shared.currentWindow?.rootViewController as? UINavigationController
        let viewController = T()
        
        if let handlerCapableVC = viewController as? CompletionHandling, let handler = dataHandler {
            handlerCapableVC.setCompletionDataHandler(handler)
        }
        
        (viewController as? DataReturnable)?.prepareInjectData(withTransferedData)
        
        switch presentationStyle {
        case .push:
            handlePush(viewController, using: navigationController, animated: animated, completion: completion)
        case .present:
            handlePresentWithNav(viewController, modalStyle: .fullScreen, transitionStyle: .coverVertical, animated: animated, completion: completion)
        case .presentWithPresentationStyle(let modalStyle, let transitionStyle):
            handlePresentWithNav(viewController, modalStyle: modalStyle, transitionStyle: transitionStyle, animated: animated, completion: completion)
        case .presentWithoutNavigation(modalStyle: let modalStyle, transitionStyle: let transitionStyle):
            handlePresent(viewController, modalStyle: modalStyle, transitionStyle: transitionStyle, animated: animated, completion: completion)
        }
    }
    
    private func handlePush(_ viewController: UIViewController, using navigationController: UINavigationController?, animated: Bool, completion: (() -> Void)?) {
        if let navController = navigationController {
            navController.pushViewController(viewController, animated: animated)
            completion?()
            return
        }
        let presentingController = UIApplication.shared.currentWindow?.rootViewController
        let newNavController = UINavigationController(rootViewController: viewController)
        presentingController?.present(newNavController, animated: animated, completion: completion)
    }
    
    private func handlePresentWithNav(_ viewController: UIViewController,
                                      modalStyle: UIModalPresentationStyle,
                                      transitionStyle: UIModalTransitionStyle,
                                      animated: Bool,
                                      completion: (() -> Void)?) {
        let newNavController = UINavigationController(rootViewController: viewController)
        newNavController.modalPresentationStyle = modalStyle
        newNavController.modalTransitionStyle = transitionStyle

        let presentingController = UIApplication.shared.currentWindow?.rootViewController
        presentingController?.present(newNavController, animated: animated, completion: completion)
    }
    
    private func handlePresent(_ viewController: UIViewController,
                               modalStyle: UIModalPresentationStyle,
                               transitionStyle: UIModalTransitionStyle,
                               animated: Bool,
                               completion: (() -> Void)?) {
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = transitionStyle

        let presentingController = UIApplication.shared.currentWindow?.rootViewController
        presentingController?.present(viewController, animated: animated, completion: completion)
    }
}

extension UIApplication {
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return keyWindow
        }
    }
}
