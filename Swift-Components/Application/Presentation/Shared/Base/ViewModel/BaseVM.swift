//
//  BaseVM.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class BaseVM {
    
    required init() {
        prepareInit()
    }
    
    func prepareInit() {
        
    }
}

