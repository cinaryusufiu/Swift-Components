//
//  TableListVC.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import UIKit
import RxSwift

final class TableListVC: BaseVC<ListVM> {
    
    private let buttonClose: AppButton = AppButton(type: .close)
    
    override var theme: BaseVC<ListVM>.VCTheme {
        var config = VCTheme.NavBarConfig.init()
        config.isHidden = false
        config.leftItems = [buttonClose]
        return VCTheme(config: config, title: "TableList VC" , pageStyle: .tableList)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func bindUI() {
        super.bindUI()
        
        buttonClose.touchUp = { [weak self] (sender) in
            self?.dismiss(animated: true)
        }
        
        tableView.rx.modelSelected(ListItemModel.self)
            .subscribe(onNext: { model in
                print("Selected City: \(model.title), Key: \(model.key)")
            })
            .disposed(by: disposeBag)
    }
    
    override func prepareInjectData(_ data: ModelTransferable?) {
        super.prepareInjectData(data)
        print("TableList Sayfasına data geldi")
        
        completionDataHandler?(ExampleTransferedData(content: "Data TableListVC"))
    }
    
    override func bindVM() {
        super.bindVM()
        let input = ListVM.Input(refresh: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(cellIdentifier: String(describing: UITableViewCell.self), cellType: UITableViewCell.self)) { _, model, cell in
                cell.textLabel?.text = "\(model.title) (\(model.key))"
            }
            .disposed(by: disposeBag)
    }
    
    override func prepareUI() {
        super.prepareUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:String(describing: UITableViewCell.self))
    }
}
