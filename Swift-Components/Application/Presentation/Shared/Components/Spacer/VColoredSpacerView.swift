//
//  VColoredSpacerView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

final class VColoredSpacerView: BaseView {
    
    init(height: CGFloat = 48, color: UIColor) {
        super.init()
        prepareUI(height,color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(_ height: CGFloat, _ color: UIColor) {
        self.backgroundColor = color
        
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}
