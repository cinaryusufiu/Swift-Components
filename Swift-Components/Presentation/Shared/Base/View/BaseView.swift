//
//  BaseView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit

class BaseView: UIView {
    
    init() {
        super.init(frame: .zero)
        prepareInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareInit()
    }
    
    func prepareInit() {
        
    }
    
    func configureGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture() {
        
    }
}
