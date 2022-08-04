//
//  NewsCategoryCollectionViewCell.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import UIKit

class NewsCategoryCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .black : .systemGray6
            categorylabel.textColor = isSelected ? .white : .black
        }
    }
    
    let categorylabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    func configure(with category: String) {
        layer.masksToBounds = true
        layer.cornerRadius = 17
        categorylabel.text = category
    }
    
    func setUpViews(){
        
        backgroundColor = .systemGray6
        
        contentView.addSubview(categorylabel)
        categorylabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(2)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.bottom.equalTo(contentView).offset(-2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
