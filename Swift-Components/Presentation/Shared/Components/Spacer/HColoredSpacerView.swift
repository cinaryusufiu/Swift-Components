//
//  HColoredSpacerView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

final class HColoredSpacerView: BaseView {
    
    init(width: CGFloat = 24, color: UIColor) {
        super.init()
        prepareUI(width,color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(_ width: CGFloat, _ color: UIColor) {
        self.backgroundColor = color
        
        self.snp.makeConstraints { make in
            make.width.equalTo(width)
        }
    }
}
