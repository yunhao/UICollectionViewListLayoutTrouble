//
//  ListViewController.swift
//  UICollectionViewListLayoutTrouble
//
//  Created by yunhao on 2023/4/5.
//

import UIKit
import os
import SwiftUI

class ListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    
    var collectionView: UICollectionView!
    
    var collectionLayout: UICollectionViewLayout!
    
    var dataSource: DataSource!
    
    override func loadView() {
        prepareCollectionView()
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        prepareDataSource()
        applyInitialSnapshots()
    }
    
    // MARK: - Prepare Collection View

    func prepareCollectionView() {
        let listConfiguraiton = UICollectionLayoutListConfiguration(appearance: .grouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguraiton)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
    }
    
    func prepareDataSource() {
        let customCellRegistration = makeCustomCellRegistration()
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: customCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    // MARK: - Apply Snapshots
    
    var items: [String] = (0..<20).map { "item - \($0)" }
    
    func applyInitialSnapshots() {
        var snapshot = Snapshot()
        snapshot.appendSections(["Section 1"])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
    // MARK: - Cell Registrations
    
    func makeCustomCellRegistration() -> UICollectionView.CellRegistration<CustomListCell, String> {
        return .init { cell, indexPath, itemIdentifier in
            var content = CustomContentConfiguration()
            content.image = UIImage(systemName: "circle")
            content.text = "\(itemIdentifier)"
            content.onTap = { [weak self] in
                self?.reloadItem(identifier: itemIdentifier)
            }
            cell.contentConfiguration = content
            cell.setNeedsUpdateConfiguration()
        }
    }
    
    private func reloadItem(identifier: String) {
        let previousContentOffsetY = collectionView.contentOffset.y
        let itemIndexPath = dataSource.indexPath(for: identifier)!
        let cell = collectionView.cellForItem(at: itemIndexPath)!
        
        NSLog("*********************************************************")
        NSLog("[Before Reload] contentOffset.y: \(collectionView.contentOffset.y)")
        NSLog("[Before Reload] cell.frame.height: \(cell.frame.height)")
        
        NSLog("[Reload] reload item at IndexPath(item: \(itemIndexPath.item), section: \(itemIndexPath.section))")
        
        // Reload item
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([identifier])
        dataSource.apply(snapshot) {
            
            let cell = self.collectionView.cellForItem(at: itemIndexPath)!
            
            NSLog("[After Reload] contentOffset.y: \(self.collectionView.contentOffset.y)")
            NSLog("[After Reload] cell.frame.height: \(cell.frame.height)")
            
            NSLog("[What's Wrong] collection view scrolls and contentOffset.y changes from \(previousContentOffsetY) to \(self.collectionView.contentOffset.y)")
            
            // FIXME: Why does the content offset change?
        }
    }
}
