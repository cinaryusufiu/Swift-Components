//
//  LargeLabelProvider.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 13.06.2024.
//

import UIKit

struct LargeLabelProvider: LabelStyleProvider {
    var style: Style<UILabel> {
        return Style<UILabel> {
            $0.textColor = UIColor.blue
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
}
