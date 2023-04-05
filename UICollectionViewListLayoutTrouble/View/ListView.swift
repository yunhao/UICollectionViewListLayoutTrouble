//
//  ContentView.swift
//  UICollectionViewListLayoutTrouble
//
//  Created by yunhao on 2023/4/5.
//

import SwiftUI

struct ListView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ListViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().ignoresSafeArea()
    }
}
