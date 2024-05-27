//
//  BaseLabel.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 21.05.2024.
//

import UIKit

protocol BaseStylable {
    var styleType: BaseLabel.StyleLabel { get set }
}

class BaseLabel: UILabel, BaseStylable {
    
    enum StyleLabel {
        case small
        case medium
        case large
    }
    
    var styleType: StyleLabel = .medium {
        didSet {
            prepareStyleUI()
        }
    }
    
    var textInsets: UIEdgeInsets = .zero
    
    convenience init() {
        self.init(styleType: StyleLabel.medium)
    }
    
    init(styleType: StyleLabel) {
        super.init(frame: .zero)
        self.styleType = styleType
        prepareStyleUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func prepareStyleUI() {
        switch styleType {
        case StyleLabel.small:
            prepareSmallStyleUI()
        case StyleLabel.medium:
            prepareMediumStyleUI()
        case StyleLabel.large:
            prepareLargeStyleUI()
        }
    }
    
    func prepareSmallStyleUI() {}
    func prepareMediumStyleUI() {}
    func prepareLargeStyleUI() {}
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}


import UIKit

final class TitleLabel: BaseLabel {
    
    override func prepareStyleUI() {
        super.prepareStyleUI()
        numberOfLines = 0
    }
    
    override func prepareLargeStyleUI() {
        super.prepareLargeStyleUI()
        font = .systemFont(ofSize: 22)
    }
    
    override func prepareMediumStyleUI() {
        super.prepareMediumStyleUI()
        font = .systemFont(ofSize: 14)
    }
    
    override func prepareSmallStyleUI() {
        super.prepareSmallStyleUI()
        font = .systemFont(ofSize: 8)
    }
}
