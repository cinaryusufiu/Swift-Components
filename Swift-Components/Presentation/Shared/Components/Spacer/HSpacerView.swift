//
//  HSpacerView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

final class HSpacerView: BaseView {
    
    init(width: CGFloat = 24) {
        super.init()
        prepareUI(width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(_ width: CGFloat) {
        self.snp.makeConstraints { make in
            make.width.equalTo(width)
        }
    }
}
