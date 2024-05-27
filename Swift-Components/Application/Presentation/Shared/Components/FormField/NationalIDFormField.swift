//
//  NationalIDFormField.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 25.05.2024.
//

import RxSwift
import UIKit

final class NationalIDFormField: FormField {
   
    func configure(with trigger: PublishSubject<Void>) {
       
        let validationConfig = FormField.Configuration.ValidationConfig(provider: TurkishNationalIDValidationProvider(),
                                                                        trigger: trigger)
        
        let textConfig = FormField.Configuration.TextConfig(title: "T.C Kimlik No",
                                                            maxCharacterCount: 11,
                                                            placeholder:"T.C Kimlik No",
                                                            errorMessage: "Düzgün bir T.C Kimlik No giriniz.")
        
        super.configure(with: FormField.Configuration(validationConfig: validationConfig, textConfig: textConfig))
        
        self.textField.keyboardType = .numberPad
    }
}
