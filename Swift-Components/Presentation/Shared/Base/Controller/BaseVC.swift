//
//  ExampleBaseVC.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 17.05.2024.
//

import UIKit
import SnapKit
import RxSwift

protocol BaseVCable {
    func prepareUI()
    func prepareStyleUI()
    func configureLocalize()
    func bindUI()
    func bindVM()
}

extension BaseVC {
    
    struct Constant {
        
        struct StackView {
            let spacing: CGFloat = 16
            let margin = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        let stackView = StackView()
    }
    
    enum PageStyle {
        case basic
        case scrollable
        case tableList
        case collectionList
    }
    
    struct VCTheme {
        
        struct NavBarConfig {
            var backgroundColor: UIColor = .white
            var borderColor: UIColor = .black
            var isHidden: Bool = false
            var leftItems: [UIView] = []
            var centerItems: [UIView] = []
            var rightItems: [UIView] = []
            
            init() { }
        }
        
        var config: NavBarConfig = NavBarConfig()
        var title: String = ""
        var pageStyle: PageStyle = .basic
    }
}

class BaseVC<T: BaseVM>: UIViewController, BaseVCable {
    
    //MARK: - Properties
    
    lazy var disposeBag = DisposeBag()
    var viewModel: T = T()
    
    //MARK: - UI Properties
    
    private let contentView = UIView()
    lazy var scrollView: VScrollView = VScrollView()
    
    lazy var stackView: VStackView = {
        let stackView = VStackView(spacing: Constant().stackView.spacing)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        stackView.layoutMargins = Constant().stackView.margin
        return stackView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .clear
        cv.contentInset = .zero
        return cv
    }()
    
    var theme: VCTheme {
        return VCTheme()
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture()
        prepareNavigationBar()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = theme.config.isHidden
    }
    
    //MARK: - Private Functions
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: - Override Functions
    
    func prepareStackView() {
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        onTappedGesture()
    }
    
    func onTappedGesture() {
        view.endEditing(true)
    }
    
    func prepareUI() {
        switch theme.pageStyle {
        case .basic:
            break
        case .scrollable:
            prepareScrollView()
        case .tableList:
            prepareTableView()
        case .collectionList:
            prepareCollectionView()
        }
        prepareStyleUI()
        bindVM()
        bindUI()
        configureLocalize()
    }
    
    func prepareStyleUI() { }
    
    func configureLocalize() { }
    
    func bindUI() { }
    
    func bindVM() { }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if theme.pageStyle == .collectionList {
            prepareCollectionItemSize()
        }
    }
    
    func prepareCollectionItemSize() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 100)
    }
}

extension BaseVC {
    
    func prepareNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.navigationBar.isTranslucent = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.navigationBar.isHidden = theme.config.isHidden
        navigationController.navigationBar.barTintColor = theme.config.backgroundColor
        navigationController.navigationBar.shadowImage = theme.config.borderColor == .clear ? UIImage() : nil
        
        if !theme.config.leftItems.isEmpty {
            navigationController.navigationBar.topItem?.leftBarButtonItems = []
        }
        
        if !theme.config.rightItems.isEmpty {
            navigationController.navigationBar.topItem?.rightBarButtonItems = []
        }
        
        if !theme.config.centerItems.isEmpty {
            navigationController.setCenterItems(theme.config.centerItems)
        }
        
        theme.config.leftItems.forEach({
            let barButtonItem = UIBarButtonItem(customView: $0)
            navigationController.navigationBar.topItem?.leftBarButtonItems?.append(barButtonItem)
        })
        
        theme.config.rightItems.forEach({
            let barButtonItem = UIBarButtonItem(customView: $0)
            navigationController.navigationBar.topItem?.rightBarButtonItems?.append(barButtonItem)
        })
        
        title = self.theme.title
    }
}

extension BaseVC {
    
    private func prepareScrollView() {
        
        if view.subviews.contains(scrollView) {
            scrollView.removeFromSuperview()
        }
        view.addSubview(scrollView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        prepareAnchorStackAndScroll()
        prepareStackView()
    }
    
    private func prepareAnchorStackAndScroll() {
        
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalTo(scrollView.snp.width)
        }
        
        stackView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
    }
}

extension BaseVC {
    
    private func prepareTableView() {
        view.addSubview(tableView)
        prepareAnchorTableView()
    }
    
    private func prepareAnchorTableView() {
        
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(8)
        }
    }
}

extension BaseVC {
    
    private func prepareCollectionView() {
        view.addSubview(collectionView)
        prepareAnchorCollectionView()
    }
    
    private func prepareAnchorCollectionView() {
        
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
