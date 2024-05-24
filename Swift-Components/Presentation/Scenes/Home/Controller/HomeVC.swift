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
    
    // MARK: - UI Properties
    
    private let buttonTableList: AppButton = AppButton(type: .detailDisclosure)
    private let buttonCollectionList: AppButton = AppButton(type: .detailDisclosure)
    private let formFieldEmail: EmailFormField = EmailFormField()
    private let formFieldNationalId: NationalIDFormField = NationalIDFormField()
    
    override var theme: BaseVC<HomeVM>.VCTheme {
        var config = VCTheme.NavBarConfig.init()
        config.isHidden = false
        config.leftItems = [buttonTableList]
        config.rightItems = [buttonCollectionList]
        return VCTheme(config: config, title: "Home VC" , pageStyle: .scrollable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func bindUI() {
        super.bindUI()
        
        buttonTableList.touchUp = { [weak self] (sender) in
            self?.navigationController?.pushViewController(TableListVC(), animated: true)
        }
        
        buttonCollectionList.touchUp = { [weak self] (sender) in
            self?.navigationController?.pushViewController(CollectionListVC(), animated: true)
        }
        
        formFieldEmail.configure(with: triggerEmail)
        formFieldNationalId.configure(with: triggerNationalID)
        
        //Default değer atamak için kullanılır.
        formFieldEmail.setSelectedValue("cinaryusufiu@gmail.com")
        
        Observable
            .merge(formFieldEmail.didEditingChanged(),
                   formFieldNationalId.didEditingChanged())
            .subscribe(onNext: {
                //Trigger'ın dinlendiği alan. isValid ile doğrulamaların yapılığ yapılmadığını görüntüleyebileceğiz
                //formFieldEmail.isValid()
            }).disposed(by: disposeBag)
        
        Observable
            .merge(formFieldEmail.didEndEditing(),
                   formFieldNationalId.didEndEditing())
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    override func prepareStackView() {
        super.prepareStackView()
        stackView.addArrangedSubview(VColoredSpacerView(height: 10, color: .white))
        stackView.addArrangedSubview(formFieldEmail)
        stackView.addArrangedSubview(formFieldNationalId)
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .purple))
    }
}
