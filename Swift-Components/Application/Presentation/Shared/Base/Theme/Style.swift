//
//  Style.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 13.06.2024.
//

import Foundation

struct Style<T> {
    let apply: (T) -> Void
    
    init(apply: @escaping (T) -> Void) {
        self.apply = apply
    }
    
    func apply(to item: T) {
        apply(item)
    }
}
