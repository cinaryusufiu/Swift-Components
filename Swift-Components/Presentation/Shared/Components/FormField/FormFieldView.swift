//
//  FormFieldView.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 21.05.2024.
//

import UIKit

final class FormFieldView: BaseView {
    
    // MARK: - Properties
    
    var config: FormField.Configuration.TextConfig? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Properties
    
    private let labelTitle: TitleLabel = TitleLabel()
    private let labelMessage: TitleLabel = TitleLabel()
    private let labelError: TitleLabel = TitleLabel()
    
    private let viewContainer: ColoredView = {
        let view = ColoredView(backgroundColor: .white)
        view.layer.borderColor = UIColor.brown.cgColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        return view
    }()
    
    private let stackView: VStackView = {
        let stackView = VStackView(spacing: 10)
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return stackView
    }()
    
    private let buttonRight: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-down-line"), for: .normal)
        return button
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        return textField
    }()
    
    // MARK: - Initialization
    
    override func prepareInit() {
        super.prepareInit()
        prepareUI()
    }
    
    // MARK: - Private Functions
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(stackView)
        stackView.addArrangedSubview(labelTitle)
        stackView.addArrangedSubview(viewContainer)
        stackView.addArrangedSubview(labelError)
        stackView.addArrangedSubview(labelMessage)
        
        viewContainer.addSubview(textField)
        viewContainer.addSubview(buttonRight)
        
        prepareUIConstraints()
    }
    
    override func bindUI() {
        super.bindUI()
        textField.delegate = self
    }
    
    private func prepareUIConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewContainer.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(buttonRight.snp.leading).inset(16)
        }
        
        buttonRight.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    override func prepareStyleUI() {
        super.prepareStyleUI()
        labelTitle.textColor = .black
        labelMessage.textColor = .gray
        labelError.textColor = .red
    }
    
    func showError() {
        guard let errorMessage = config?.errorMessage else { return }
        labelError.text = errorMessage
        labelError.isHidden = false
        labelMessage.isHidden = true
        viewContainer.layer.borderColor = UIColor.red.cgColor
    }
    
    func hideError() {
        labelError.isHidden = true
        labelMessage.isHidden = labelMessage.text == nil
        viewContainer.layer.borderColor = UIColor.black.cgColor
    }
    
    func prepareTextFieldPlaceHolder() {
        guard let placeholder = config?.placeholder else { return }
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.5)]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    override func updateUI() {
        super.updateUI()
        
        labelTitle.text = config?.title
        labelMessage.text = config?.description
        labelMessage.isHidden = config?.description == nil
        
        buttonRight.setTitle(config?.rightButtonTitle, for: .normal)
        buttonRight.setImage(config?.rightButtonImage, for: .normal)
        prepareTextFieldPlaceHolder()
    }
    
    func updateUIDidBeginEditing() {
        viewContainer.backgroundColor = .white
        viewContainer.layer.borderColor = UIColor.green.cgColor
    }
    
    func updateUIDidEndEditing() {
        viewContainer.layer.borderColor = UIColor.gray.cgColor
    }
}

extension FormFieldView: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let maxCount = config?.maxCharacterCount {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= maxCount
        }
        return true
    }
}
