//
//  StockCell.swift
//  StocksApp
//
//  Created by Olzhas Seiilkhanov on 25.07.2022.
//

import UIKit
import Kingfisher
import SkeletonView

class StockCell: UITableViewCell {
    
    var onFavouriteDidTap: (() -> Void)?
    
    let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()
    private let logoImageVIew: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.isSkeletonable = true
        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.isSkeletonable = true
        return label
    }()
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.isSkeletonable = true
        return label
    }()
    let starImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star")
        image.isSkeletonable = true
        return image
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "$123.42"
        label.isSkeletonable = true
        return label
    }()
    let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.text = "+$0.12 (1,15%)"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 12)
        label.isSkeletonable = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        configureImageView()
//        nameLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
//        logoImageVIew.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
//        tickerLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
//        priceLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
//        priceChangeLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
//        starImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favouriteTapped(tapGestureRecognizer:)))
        starImageView.isUserInteractionEnabled = true
        starImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func favouriteTapped(tapGestureRecognizer: UIGestureRecognizer) {
        onFavouriteDidTap?()
    }
    
    func setUp(with stock: Stock) {
        nameLabel.text = stock.profile?.name
        tickerLabel.text = (stock.ticker?.displaySymbol)
        priceLabel.text = "$\(stock.quote?.c ?? 0)"
        priceChangeLabel.text = "\(stock.quote?.d ?? 0) \(stock.quote?.dp ?? 0)%"
        
        // Coloring price
        guard let priceChange = stock.quote?.d else { return }
        if priceChange < 0 {
            priceChangeLabel.textColor = .red
        } else {
            priceChangeLabel.textColor = .systemGreen
            
        }
        
        
        // Setting default image
        logoImageVIew.kf.setImage(with: URL(string: stock.profile?.logo ?? ""), placeholder: UIImage(named: "default.jpeg"))    
    }

    
    private func makeConstraints() {
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        selectionStyle = .none
        
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-18)
            make.top.equalTo(contentView.snp.top).offset(4)
            make.bottom.equalTo(contentView.snp.bottom).offset(-4)
        }
        
        
        cellView.addSubview(logoImageVIew)
        logoImageVIew.snp.makeConstraints { make in
            make.top.equalTo(cellView).offset(16)
            make.bottom.equalTo(cellView).offset(-16)
            make.leading.equalTo(cellView).offset(8)
            make.height.width.equalTo(50)
        }
        
        cellView.addSubview(tickerLabel)
        tickerLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageVIew.snp.trailing).offset(16)
            make.top.equalTo(logoImageVIew.snp.top).offset(4)
        }
        
        cellView.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.leading.equalTo(tickerLabel.snp.trailing).offset(3)
            make.top.equalTo(logoImageVIew.snp.top).offset(4)
            make.height.width.equalTo(18)
        }
        
        cellView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImageVIew.snp.trailing).offset(16)
            make.top.equalTo(tickerLabel.snp.bottom).offset(4)
            make.width.equalTo(200)
        }
        
        cellView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(cellView).offset(-8)
            make.top.equalTo(logoImageVIew.snp.top).offset(4)
        }
        
        cellView.addSubview(priceChangeLabel)
        priceChangeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(cellView).offset(-8)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
        }
    }

}
