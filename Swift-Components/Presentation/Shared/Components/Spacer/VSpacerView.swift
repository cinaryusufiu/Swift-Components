//
//  VSpacerView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

final class VSpacerView: BaseView {
    
    init(height: CGFloat = 48) {
        super.init()
        prepareUI(height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(_ height: CGFloat) {
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}
