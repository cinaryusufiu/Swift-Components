//
//  HStackView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

final class HStackView: UIStackView {
    
    init(spacing: CGFloat) {
        super.init(frame: .zero)
        self.spacing = spacing
        prepareInit()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareInit() {
        backgroundColor = .clear
        axis = .horizontal
        alignment = .fill
        distribution = .fill
    }
}
