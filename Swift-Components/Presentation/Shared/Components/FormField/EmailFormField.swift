//
//  EmailFormField.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 21.05.2024.
//

import UIKit
import RxSwift

final class EmailFormField: FormField {
    
    func configure(with trigger: PublishSubject<Void>) {
        
        let validationConfig = FormField.Configuration.ValidationConfig(provider: EmailValidationProvider(),
                                                                        trigger: trigger)
        
        let textConfig = FormField.Configuration.TextConfig(title: "E-Posta Adresi",
                                                            placeholder: "E-Posta Adresi Giriniz",
                                                            errorMessage: "Düzgün bir E-Posta Adresi giriniz.")
        
        super.configure(with: FormField.Configuration(validationConfig: validationConfig, textConfig: textConfig))
        
        self.textField.keyboardType = .emailAddress
    }
}
