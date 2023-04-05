#  UICollectionViewListLayoutTrouble

The purpose of this project is to reproduce the problem when using `UICollectionView` and `UICollectionLayoutListConfiguration`.

```swift
let listConfiguraiton = UICollectionLayoutListConfiguration(appearance: .grouped)
let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguraiton)
collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
```

The demo uses `UICollectionViewDiffableDataSource` to manage data and provide cells for the collection view.

```swift
dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
    return collectionView.dequeueConfiguredReusableCell(using: customCellRegistration, for: indexPath, item: itemIdentifier)
}
```

There is only one kind of cell in the collection view. The height of the cell is about 141 pt.

## What's the trouble

When using a collection view with list configuration, calling `reloadItems(_:)` for a specific item will change the collection view's content offset and cause the collection view scrolls, even if the height of the item is the same before and after calling `reloadItems(_:)`.

## How to reproduce

Run the demo project, scroll to the bottom of the collection view, and tap the `Reload` button in the last cell. Then you will see the collection view scrolls some distance.
