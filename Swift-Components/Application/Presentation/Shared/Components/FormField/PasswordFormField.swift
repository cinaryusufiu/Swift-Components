//
//  PasswordFormField.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 25.05.2024.
//

import RxSwift
import UIKit

class PasswordFormField: FormField {
    
    func configure(with trigger: PublishSubject<Void>) {
       
        let validationConfig = FormField.Configuration.ValidationConfig(provider: CountValidationProvider(range: NSRange(location: 5, length: 12)),
                                                                        trigger: trigger)
        
        let textDefaultConfig = FormField.Configuration.TextConfig(title: "Şifre",
                                                                   placeholder: "Şifrenizi Giriniz",
                                                                   errorMessage:  "Şifre alanı boş geçilemez.")
        
        super.configure(with: FormField.Configuration(validationConfig: validationConfig,
                                                      textConfig: textDefaultConfig))
    }
   
    func configure(with trigger: PublishSubject<Void>, textConfig: FormField.Configuration.TextConfig) {
       
        let validationConfig = FormField.Configuration.ValidationConfig(provider: CountValidationProvider(range: NSRange(location: 6, length: 12)),
                                                                        trigger: trigger)
        
        
        super.configure(with: FormField.Configuration(validationConfig: validationConfig,
                                                      textConfig: textConfig))
    }
    
    override func prepareUI() {
        super.prepareUI()
        
        self.textField.isSecureTextEntry = true
        self.buttonRight.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .normal)
        self.buttonRight.rx
            .tap
            .asObservable()
            .subscribe({ [weak self] _ in
                guard let self = self else { return }
                self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
                let image = self.textField.isSecureTextEntry == true ?  UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
                self.buttonRight.setBackgroundImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}

final class PasswordRepeatFormField: PasswordFormField {
    
    override func configure(with trigger: PublishSubject<Void>) {
        
        let textConfig = FormField.Configuration.TextConfig(title: "Şifre (tekrar)",
                                                                   placeholder: "Şifre (tekrar)",
                                                                   errorMessage:  "Şifre alanı boş geçilemez.")
        super.configure(with: trigger, textConfig: textConfig)
    }
}
