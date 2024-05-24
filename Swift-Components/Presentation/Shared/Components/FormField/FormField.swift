//
//  FormField.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 21.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

extension FormField {
    
    struct Configuration {
        
        struct TextConfig {
            var title: String?
            var rightButtonTitle: String?
            var rightButtonImage: UIImage?
            var maxCharacterCount: Int?
            var placeholder: String?
            var description: String?
            var errorMessage: String?
        }
        
        struct ValidationConfig {
            var provider: ValidationProvider?
            var trigger: PublishSubject<Void>? = nil
        }
        
        var validationConfig: ValidationConfig?
        var textConfig: TextConfig?
    }
}

class FormField: BaseView {
    
    // MARK: - Properties
    
    var selectedValue: BehaviorSubject<String> = BehaviorSubject(value: "")
    private var config: Configuration?
    
    // MARK: - UI Properties
    
    let formField: FormFieldView = FormFieldView()
    
    var textField: UITextField {
        return formField.textField
    }
    
    override func prepareUI() {
        super.prepareUI()
        
        addSubview(formField)
        formField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareStyleUI() {
        super.prepareStyleUI()
        backgroundColor = .clear
    }
    
    override func bindUI() {
        super.bindUI()
        bindHighlight()
        bindSelectedValue()
        if let validationConfig = config?.validationConfig, validationConfig.provider != nil {
            bindValidation(provider: validationConfig.provider!, trigger: validationConfig.trigger)
        }
    }
}

extension FormField {
    
    func setSelectedValue(_ value: String) {
        
        guard let validationConfig = config?.validationConfig, let provider = validationConfig.provider else {
            selectedValue.onNext(value)
            self.config?.validationConfig?.trigger?.onNext(())
            return
        }
        
        switch textField.validateText(value, with: provider) {
        case .success:
            selectedValue.onNext(value)
            validationConfig.trigger?.onNext(())
        case .failure:
            break
        }
    }
    
    func isValid() -> ValidationResult {
        guard let validationConfig = config?.validationConfig, let provider = validationConfig.provider else {
            return .success
        }
        return textField.validateText(formField.textField.text, with: provider)
    }
}

extension FormField {
    
    public func configure(with config: Configuration) {
        self.config = config
        formField.config = config.textConfig
        bindUI()
    }
}

extension FormField {
    
    // MARK: - Private Functions
    
    private func bindHighlight() {
        formField.textField.didBegin().subscribe(onNext: { [weak self] in
            self?.formField.updateUIDidBeginEditing()
        }).disposed(by: disposeBag)
        
        formField.textField.didEndEditing().subscribe(onNext: { [weak self] in
            self?.formField.updateUIDidEndEditing()
        }).disposed(by: disposeBag)
    }
    
    private func bindSelectedValue() {
        formField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: selectedValue)
            .disposed(by: disposeBag)
        
        selectedValue
            .asObservable()
            .distinctUntilChanged()
            .bind(to: formField.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindValidation(provider: ValidationProvider, trigger: PublishSubject<Void>?) {
        guard let trigger = trigger else { return }
        
        Observable.merge( textField.didEditingChanged(),
                          textField.didEndEditing(),
                          trigger.asObservable())
        
        .flatMapLatest { [weak self] in
            let value = self?.formField.textField.text
            return Observable.just(self?.textField.validateText(value, with: provider) ?? .failure("Validation failed"))
        }.subscribe(onNext: { [weak self] result in
            switch result {
            case .success:
                self?.formField.hideError()
            case .failure(let message):
                self?.formField.showError()
            }
        }).disposed(by: disposeBag)
    }
}

enum ValidationResult: Equatable {
    case success
    case failure(String)
    
    var isValid: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case let .failure(message) = self {
            return message
        }
        return nil
    }
    
    static func validateRegex(_ text: String?, regex: String) -> ValidationResult {
        guard let text = text else { return .failure("Input is nil") }
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text) ? .success : .failure("Invalid format")
    }
}

protocol ValidationProvider {
    func validate(_ text: String?) -> ValidationResult
}

final class EmailValidationProvider: ValidationProvider {
    func validate(_ text: String?) -> ValidationResult {
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        return ValidationResult.validateRegex(text, regex: emailRegex)
    }
}

final class UsernameValidationProvider: ValidationProvider {
    func validate(_ text: String?) -> ValidationResult {
        let userNameRegex = "^[A-Za-zğüşöçİĞÜŞÖÇ]+(?:[ _.-][A-Za-zğüşöçİĞÜŞÖÇ]+)*$"
        return ValidationResult.validateRegex(text, regex: userNameRegex)
    }
}

final class EmptyValidationProvider: ValidationProvider {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text, !text.isEmpty else { return .failure("Input is empty") }
        return .success
    }
}

final class CountValidationProvider: ValidationProvider {
    let range: NSRange
    
    init(range: NSRange) {
        self.range = range
    }
    
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text, !text.isEmpty, text.count >= range.location, text.count <= range.length else {
            return .failure("Input does not meet the character count requirements")
        }
        return .success
    }
}

final class CharacterSetValidationProvider: ValidationProvider {
    let characterSet: CharacterSet
    
    init(characterSet: CharacterSet) {
        self.characterSet = characterSet
    }
    
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text, !text.isEmpty else { return .failure("Input is empty") }
        let isSuccess = text.unicodeScalars.allSatisfy { characterSet.contains($0) }
        return isSuccess ? .success : .failure("Input contains invalid characters")
    }
}

final class TurkishNationalIDValidationProvider: ValidationProvider {
    
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text, !text.isEmpty else {
            return .failure("Input is empty")
        }
        
        let idRegex = "^[1-9][0-9]{10}$"
        guard ValidationResult.validateRegex(text, regex: idRegex).isValid else {
            return .failure("Invalid format")
        }
        
        let digits = text.compactMap({ $0.wholeNumberValue })
        
        if digits.count != 11 {
            return .failure("Invalid ID")
        }
        
        let first10Digits = digits.prefix(10)
        let eleventhDigit = digits.last!
        
        let sumOdd = first10Digits.enumerated().filter({ $0.offset % 2 == 0 }).map({ $0.element }).reduce(0, +)
        let sumEven = first10Digits.enumerated().filter({ $0.offset % 2 != 0 && $0.offset != 9 }).map({ $0.element }).reduce(0, +)
        
        let checkDigit10 = ((sumOdd * 7) - sumEven) % 10
        let checkDigit11 = (first10Digits.reduce(0, +)) % 10
        
        if checkDigit10 == digits[9] && checkDigit11 == eleventhDigit {
            return .success
        } else {
            return .failure("Invalid National ID")
        }
    }
}

final class TurkishPhoneNumberValidationProvider: ValidationProvider {
    func validate(_ text: String?) -> ValidationResult {
        guard let text = text, !text.isEmpty else {
            return .failure("Input is empty")
        }
        
        let phoneRegex = "(^\\+90\\s?\\d{3}\\s?\\d{3}\\s?\\d{2}\\s?\\d{2}$)|(^0?5\\d{9}$)"
        
        return ValidationResult.validateRegex(text, regex: phoneRegex)
    }
}

protocol ValidationHandler {}

extension ValidationHandler {
    
    func validateText(_ text: String?, with provider: ValidationProvider) -> ValidationResult {
        return provider.validate(text)
    }
}

extension UITextField: ValidationHandler { }

extension UITextField {
    
    func didPressReturn() -> Observable<Void> {
        return rx.controlEvent([.editingDidEndOnExit]).asObservable()
    }
    
    func didEndEditing() -> Observable<Void> {
        return rx.controlEvent([.editingDidEnd]).asObservable()
    }
    
    func didEditingChanged() -> Observable<Void> {
        return rx.controlEvent([.editingChanged]).asObservable()
    }
    
    func didBegin() -> Observable<Void> {
        return rx.controlEvent([.editingDidBegin]).asObservable()
    }
}
