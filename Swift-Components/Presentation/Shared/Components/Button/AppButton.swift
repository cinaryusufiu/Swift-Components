//
//  AppButton.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit
import SnapKit

final class AppButton: UIButton {
    
    typealias CompletionBlock = (() -> ())
    typealias CompletionButtonBlock = (_ button: UIButton) -> ()
    
    var buttonOnTapped: CompletionBlock!
    var touchUp: CompletionButtonBlock?
    var touchDown: CompletionButtonBlock?
    var touchExit: CompletionButtonBlock?
    
    var title: String? = "" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    var margin: CGFloat = 0
    
    var bGColor: UIColor = .clear {
        didSet {
            self.backgroundColor = bGColor
        }
    }
    
    var radius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }
    
    var iconName: String = "" {
        didSet {
            self.setImage(UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal).withAlignmentRectInsets(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)), for: .normal)
        }
    }
    
    var titleColor: UIColor = .clear {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
    var fontLabel: UIFont? = UIFont.systemFont(ofSize: 20) {
        didSet {
            self.titleLabel?.font = fontLabel
        }
    }
    
    convenience init() {
        self.init(type: .system)
        prepareUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(){
        self.setTitle(title, for: .normal)
        self.backgroundColor = bGColor
        self.layer.cornerRadius = radius
        self.titleLabel?.font = fontLabel
        self.setTitleColor(titleColor, for: .normal)
        
        addTarget(self, action: #selector(touchDown(sender:)), for: [.touchDown , .touchDragEnter])
        addTarget(self, action: #selector(touchExit(sender:)), for: [.touchCancel, .touchDragExit])
        addTarget(self, action: #selector(touchUp(sender:)), for: [.touchUpInside])
    }
    
    @objc private func touchDown(sender: UIButton) {
        touchDown?(sender)
    }
    
    @objc private func touchExit(sender: UIButton) {
        touchExit?(sender)
    }
    
    @objc private func touchUp(sender: UIButton) {
        touchUp?(sender)
    }
}
