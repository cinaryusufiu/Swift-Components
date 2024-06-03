//
//  ViewController.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 17.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeVM: BaseVM { }

final class HomeVC: BaseVC<HomeVM> {
    
    // MARK: - Properties
    
    private let triggerEmail = PublishSubject<Void>()
    private let triggerNationalID = PublishSubject<Void>()
    private let triggerPassword = PublishSubject<Void>()
    private let triggerPasswordRepeat = PublishSubject<Void>()
    
    // MARK: - UI Properties
    
    private let buttonConfirm: AppButton = {
        let button = AppButton()
        button.isEnabled = false
        button.title = "Confirm"
        button.backgroundColor = .red
        button.titleColor = .white
        button.radius = 16
        return button
    }()
    
    private let buttonTableList: AppButton = AppButton(type: .detailDisclosure)
    private let buttonCollectionList: AppButton = AppButton(type: .detailDisclosure)
    private let formFieldEmail: EmailFormField = EmailFormField()
    private let formFieldNationalId: NationalIDFormField = NationalIDFormField()
    private let formFieldPassword: PasswordFormField = PasswordFormField()
    private let formFieldPasswordRepeat: PasswordRepeatFormField = PasswordRepeatFormField()
    
    override var theme: BaseVC<HomeVM>.VCTheme {
        var config = VCTheme.NavBarConfig.init()
        config.isHidden = false
        config.leftItems = [buttonTableList]
        config.rightItems = [buttonCollectionList]
        return VCTheme(config: config, title: "Home VC" , pageStyle: .scrollable)
    }
    
    override func prepareUI() {
        super.prepareUI()
        configureAllFormField()
        configureConfirmButton()
    }
    
    override func prepareStyleUI() {
        super.prepareStyleUI()
        self.view.backgroundColor = .white
    }
    
    override func bindUI() {
        super.bindUI()
        bindUIButtons()
        bindUIFormFields()
    }
    
    override func prepareStackView() {
        super.prepareStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 120, right: 16)
        stackView.addArrangedSubview(VColoredSpacerView(height: 10, color: .white))
        stackView.addArrangedSubview(formFieldEmail)
        stackView.addArrangedSubview(formFieldNationalId)
        stackView.addArrangedSubview(formFieldPassword)
        stackView.addArrangedSubview(formFieldPasswordRepeat)
    }
}

extension HomeVC {
    
    private func configureAllFormField() {
        formFieldEmail.configure(with: triggerEmail)
        formFieldNationalId.configure(with: triggerNationalID)
        formFieldPassword.configure(with: triggerPassword)
        formFieldPasswordRepeat.configure(with: triggerPasswordRepeat)
        
        //formFieldEmail.setSelectedValue("cinaryusufiu@gmail.com")
    }
    
    private func configureConfirmButton() {
        view.addSubview(buttonConfirm)
        
        buttonConfirm.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            maker.height.equalTo(56)
        }
    }
    
    private func bindUIButtons() {
        
        buttonTableList.touchUp = { (sender) in
            self.routeToTableListVC()
        }
        
        buttonCollectionList.touchUp = { [weak self] (sender) in
            self?.navigationController?.pushViewController(CollectionListVC(), animated: true)
        }
        
        buttonConfirm.touchUp = { [weak self] (sender) in
            self?.navigationController?.pushViewController(CollectionListVC(), animated: true)
        }
    }
    
    func routeToTableListVC() {
        Router.shared.navigate(to: TableListVC.self,
                               presentationStyle: .present,
                               withTransferedData: ExampleTransferedData(content: "Homedan data transfer edildi"),
                               withDataHandler: { data in
            print("Data Received: \(data.describe())")
        },
                               completion: {
            print("Navigation completed")
        })
    }
    
    private func bindUIFormFields() {
        Observable
            .merge(formFieldEmail.didEditingChanged(),
                   formFieldNationalId.didEditingChanged(),
                   formFieldPassword.didEditingChanged(),
                   formFieldPasswordRepeat.didEditingChanged())
            .subscribe(onNext: { [weak self] in
                self?.configureTextFieldsValidation()
            }).disposed(by: disposeBag)
        
        Observable
            .merge(formFieldEmail.didEndEditing(),
                   formFieldNationalId.didEndEditing(),
                   formFieldPassword.didEndEditing(),
                   formFieldPasswordRepeat.didEndEditing())
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    private func configureTextFieldsValidation() {
        let isValid =  [ self.formFieldEmail.isValid() ,
                         self.formFieldNationalId.isValid(),
                         self.formFieldPassword.isValid(),
                         self.formFieldPasswordRepeat.isValid()].allSatisfy({ $0 == .success })
        self.buttonConfirm.isEnabled = isValid
    }
}
