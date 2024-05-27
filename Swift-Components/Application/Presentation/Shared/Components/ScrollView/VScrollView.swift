//
//  VScrollView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

final class VScrollView: UIScrollView {
    
    init() {
        super.init(frame: .zero)
        prepareInit()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareInit() {
        backgroundColor = .clear
    }
}
