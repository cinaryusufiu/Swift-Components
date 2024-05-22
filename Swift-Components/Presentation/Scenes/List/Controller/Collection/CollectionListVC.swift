//
//  CollectionListVC.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CollectionListVC: BaseVC<ListVM> {
    
    override var theme: BaseVC<ListVM>.VCTheme {
        var config = VCTheme.NavBarConfig.init()
        config.isHidden = false
        return VCTheme(config: config, title: "Collection VC" , pageStyle: .collectionList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func bindUI() {
        super.bindUI()
        collectionView.rx.modelSelected(ListItemModel.self)
            .subscribe(onNext: { model in
                print("Selected City: \(model.title), Key: \(model.key)")
            })
            .disposed(by: disposeBag)
    }
    
    override func bindVM() {
        super.bindVM()
       
        let input = ListVM.Input(refresh: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(collectionView.rx.items(cellIdentifier: String(describing: BaseCVCell.self), cellType: BaseCVCell.self)) { _, model, cell in
                cell.textLabel.text = "\(model.title) (\(model.key))"
            }
            .disposed(by: disposeBag)
    }
  
    override func prepareUI() {
        super.prepareUI()
        collectionView.register(BaseCVCell.self, forCellWithReuseIdentifier: String(describing: BaseCVCell.self))
    }
}
