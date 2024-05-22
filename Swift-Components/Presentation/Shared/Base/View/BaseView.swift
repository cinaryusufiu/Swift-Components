//
//  BaseView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit
import RxSwift

protocol BaseViewable {
    func prepareUI()
    func prepareStyleUI()
    func configureLocalize()
    func bindUI()
    func updateUI()
}

class BaseView: UIView, BaseViewable {
   
    lazy var disposeBag = DisposeBag()
    
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
        prepareUI()
        prepareStyleUI()
        configureLocalize()
    }
    
    func configureGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture() {}
    
    func prepareUI() {}
    
    func prepareStyleUI() {}
    
    func configureLocalize() {}
    
    func bindUI() {}
    
    func updateUI() {}
}
