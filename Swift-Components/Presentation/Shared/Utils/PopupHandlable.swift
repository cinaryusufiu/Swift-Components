//
//  PopupHandlable.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

protocol PopupHandlable: UIViewController {}

extension PopupHandlable {
    
    func showPopUp(errorModel: ErrorPopupModel) { }
}

public struct ErrorPopupModel {
    var errorCode: String?
    var title: String
    var message: String
    var icon: UIImage?
}
