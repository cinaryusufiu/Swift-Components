//
//  ListVM.swift
//  Swift-Components
//
//  Created by Yusuf Çınar on 20.05.2024.
//

import RxSwift

final class ListVM: BaseVM, ViewModelType {
    
    struct Input {
        let refresh: Observable<Void>
    }
    
    struct Output {
        let items: Driver<[ListItemModel]>
    }
    
    private let cities = [
        ListItemModel(title: "Istanbul", key: "34"),
        ListItemModel(title: "Ankara", key: "06"),
        ListItemModel(title: "Izmir", key: "35"),
        ListItemModel(title: "Bursa", key: "16"),
        ListItemModel(title: "Antalya", key: "07"),
        ListItemModel(title: "Adana", key: "01"),
        ListItemModel(title: "Konya", key: "42"),
        ListItemModel(title: "Gaziantep", key: "27"),
        ListItemModel(title: "Mersin", key: "33"),
        ListItemModel(title: "Muğla", key: "48"),
        ListItemModel(title: "Eskişehir", key: "26"),
        ListItemModel(title: "Samsun", key: "55")
    ]
    
    func transform(input: Input) -> Output {
        let items = input.refresh
            .map { _ in self.randomCities() }
            .asDriver(onErrorJustReturn: [])
        
        return Output(items: items)
    }
    
    private func randomCities() -> [ListItemModel] {
        return (1...5).compactMap { _ in cities.randomElement() }
    }
}


