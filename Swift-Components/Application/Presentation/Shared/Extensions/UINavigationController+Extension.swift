//
//  UINavigationController+Extension.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

extension UINavigationController {
    
    func setCenterItems(_ items: [UIView]) {
        let containerView = UIView()
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        self.navigationBar.topItem?.titleView = containerView
    }
}
