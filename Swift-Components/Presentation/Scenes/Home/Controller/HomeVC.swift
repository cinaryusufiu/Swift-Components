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
    
    private let buttonTableList: AppButton = AppButton(type: .detailDisclosure)
    private let buttonCollectionList: AppButton = AppButton(type: .detailDisclosure)
    
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
    }
    
    override func prepareStackView() {
        super.prepareStackView()
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .purple))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .red))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .purple))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .red))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .purple))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .red))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .purple))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .red))
        stackView.addArrangedSubview(VColoredSpacerView(height: 120, color: .purple))
    }
}
