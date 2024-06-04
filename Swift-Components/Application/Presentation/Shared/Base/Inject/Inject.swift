//
//  Inject.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 3.06.2024.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    
    private var service: T?
    private var creator: (() -> T)?
    
    init() {}

    init(creator: @escaping () -> T) {
        self.creator = creator
    }

    var wrappedValue: T? {
        mutating get {
            if service == nil {
                if let creator = creator {
                   return ServiceLocator.shared.resolveOrCreate(T.self, creator: creator)
                }
                service = ServiceLocator.shared.resolve(T.self)
            }
            return service
        }
        set {
            service = newValue
        }
    }
}
