//
//  SmallLabel.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 13.06.2024.
//

import Foundation

final class SmallLabel: BaseLabel {
    
    init(provider: SmallLabelProvider = SmallLabelProvider()) {
        super.init(provider: provider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
