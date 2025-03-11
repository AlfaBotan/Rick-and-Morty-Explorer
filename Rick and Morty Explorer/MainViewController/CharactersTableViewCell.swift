//
//  CharactersTableViewCell.swift
//  Rick and Morty Explorer
//
//  Created by Илья Волощик on 11.03.25.
//

import UIKit
import Kingfisher

final class CharactersTableViewCell: UITableViewCell {
    
    static let identifer = "CharactersTableViewCell"
    
    private lazy var mainImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.kf.indicatorType = .activity
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubViews()
        contentView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubViews() {
        contentView.addSubview(mainImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        
        
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 300)
        heightCell.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightCell,
            mainImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainImage.heightAnchor.constraint(equalToConstant: 280),
            
            nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            nameLabel.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configCell(name: String, status: StatusEnum, image: URL) {
        let urlForImage = image
        mainImage.kf.setImage(
            with: urlForImage,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        nameLabel.text = "\(name)"
        switch status {
        case .dead:
            statusLabel.text = "Dead"
            statusLabel.textColor = .red
        case .alive:
            statusLabel.text = "Alive"
            statusLabel.textColor = .green
        case .unknown:
            statusLabel.text = "Unknown"
            statusLabel.textColor = .gray
        }
    }
}
