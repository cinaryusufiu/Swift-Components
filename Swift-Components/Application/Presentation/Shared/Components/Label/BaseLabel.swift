//
//  BaseLabel.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 21.05.2024.
//

import UIKit

class BaseLabel: UILabel {
    
    var provider: LabelStyleProvider
    
    init(provider: LabelStyleProvider) {
        self.provider = provider
        super.init(frame: .zero)
        prepareStyleUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareStyleUI() {
        provider.style.apply(to: self)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: .zero))
    }
}
