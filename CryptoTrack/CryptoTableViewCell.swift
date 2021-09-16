//
//  CryptoTableViewCell.swift
//  CryptoTrack
//
//  Created by Ricky Liao on 9/16/21.
//

import UIKit

class CryptoTableViewCellModel {
    let name: String
    let symbol: String
    let price: String
    let iconUrl: URL?
    var iconData: Data?
    
    init(name: String,
         symbol: String,
         price: String,
         iconUrl: URL?
         ) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}

class CryptoTableViewCell: UITableViewCell {
    static let identifier = "CryptoTableViewCell"
    
    // Subviews
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let timageView: UIImageView = {
       let timageView = UIImageView()
        timageView.contentMode = .scaleAspectFit
        return timageView
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(symbolLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(timageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height/1.1
        timageView.frame = CGRect(
            x: 20,
            y: (contentView.frame.size
                    .height-size)/2,
            width: size,
            height: size
        )
        
        nameLabel.sizeToFit()
        symbolLabel.sizeToFit()
        priceLabel.sizeToFit()
        
        
        nameLabel.frame = CGRect(
            x: 30 + size,
            y: 0,
            width: contentView.frame.size.width/2,
            height: contentView.frame.size.height/2
        )
        
        symbolLabel.frame = CGRect(
            x: 30 + size,
            y: contentView.frame.size.height/2,
            width: contentView.frame.size.width/2,
            height: contentView.frame.size.height/2
        )
        
        priceLabel.frame = CGRect(
            x: contentView.frame.size.width/2,
            y: 0,
            width: (contentView.frame.size.width/2)-15,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timageView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
    }
    
    // Configure
    
    func configure(with viewModel: CryptoTableViewCellModel) {
        nameLabel.text = viewModel.name
        symbolLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        
        if let data = viewModel.iconData {
            timageView.image = UIImage(data: data)
        }
        else if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data {
                    viewModel.iconData = data
                    DispatchQueue.main.async {
                        self?.timageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
}
