//
//  CustomListCell.swift
//  UICollectionViewListLayoutTrouble
//
//  Created by yunhao on 2023/4/6.
//

import UIKit

struct CustomContentConfiguration: UIContentConfiguration {
    var image: UIImage?
    var text: String?
    var onTap: (() -> Void)?
    
    func makeContentView() -> UIView & UIContentView {
        return CustomContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

class CustomContentView: UIView, UIContentView {
    init(configuration: CustomContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? CustomContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private let imageButton = UIButton(configuration: .borderless())
    private let textLabel = UILabel()
    private let primaryButton = UIButton(configuration: .bordered())
    
    private func setupInternalViews() {
        addSubview(imageButton)
        addSubview(textLabel)
        addSubview(primaryButton)
        
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageButton.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            imageButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
        ])
        imageButton.configuration?.preferredSymbolConfigurationForImage = .init(font: .preferredFont(forTextStyle: .largeTitle), scale: .large)
        imageButton.configurationUpdateHandler = { button in
            button.configuration?.image = button.isSelected ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        }
        imageButton.addTarget(self, action: #selector(imageButtonDidTap(_:)), for: .touchUpInside)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 8),
        ])
        
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryButton.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            primaryButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
            primaryButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        primaryButton.setTitle("Reload", for: .normal)
        primaryButton.setTitleColor(.darkText, for: .normal)
        primaryButton.addTarget(self, action: #selector(primaryButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private var appliedConfiguration: CustomContentConfiguration!
    
    private func apply(configuration: CustomContentConfiguration) {
        appliedConfiguration = configuration
        textLabel.text = configuration.text
        imageButton.isSelected = false
        imageButton.configuration?.image = configuration.image
    }
    
    @objc func imageButtonDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func primaryButtonDidTap(_ sender: UIButton) {
        (configuration as? CustomContentConfiguration)?.onTap?()
    }
}

class CustomListCell: UICollectionViewCell {
    
}
