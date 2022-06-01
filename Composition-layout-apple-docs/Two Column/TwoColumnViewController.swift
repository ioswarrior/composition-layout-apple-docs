//
//  TwoColumnViewController.swift
//  Composition-layout-apple-docs
//
//  Created by Muller Alexander on 01.06.2022.
//

import UIKit

class TwoColumnViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Two-Column Grid"
        configureHierarchy()
        configureDataSource()
    }
}

extension TwoColumnViewController {
    private func createLayout() -> UICollectionViewLayout {
        // Объект itemSize определяет высоту и ширину элемента, NSCollectionLayoutSize — определяет размер элемента
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        // NSCollectionLayoutItem — определяет элемент лайаута
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // NSCollectionLayoutGroup — определяет группу элементов лайаута, сам по себе тоже является элементом лайута
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        
        // NSCollectionLayoutGroup — определяет группу элементов лайаута, сам по себе тоже является элементом лайута
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let spacing = CGFloat(10)
        // interItemSpacing - Расстояние между элементами в группе. Cлева/справа
        group.interItemSpacing = .fixed(spacing)
        
        // NSCollectionLayoutSection — определяет секцию для конкретной группы элементов
        let section = NSCollectionLayoutSection(group: group)
        // Отступы вверх/низ
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // UICollectionViewCompositionalLayout — определяет сам лайаут
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension TwoColumnViewController {
    private func configureHierarchy() {
        // Создание коллекции
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        // Поведение автоматического изменения размера относительно superview
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        // Регистрация ячеек коллекции
        // В следующем примере создается регистрация ячейки для ячеек типа TextCell
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .systemGreen
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        // Объект, который вы используете для управления данными и предоставления ячеек для коллекции.
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            
            // "Удаляет" из очереди сконфигурированный повторно используемый объект ячейки
            // Возвращает сконфигурированный многоразовый объект ячейки
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // Да, для "закидывания данных" (а ещё чтобы под капотом скрыть всю работу с дифами и их правильным применением). Они нужны для упрощения старого апи, из-за хренового дизайна которого кто-то постоянно простреливал себе ногу.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
