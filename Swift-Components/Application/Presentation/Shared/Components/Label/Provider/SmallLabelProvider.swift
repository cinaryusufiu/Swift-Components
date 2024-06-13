//
//  SmallLabelProvider.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 13.06.2024.
//

import UIKit

struct SmallLabelProvider: LabelStyleProvider {
    var style: Style<UILabel> {
        return Style<UILabel> {
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 12)
        }
    }
}
