//
//  NewsTableViewCell.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import UIKit
import SkeletonView

typealias CallBack = () -> Void

class NewsTableViewCell: UITableViewCell {

    static var identifier = "NewsTableViewCell"
    
    var onWebsiteLinkButtonDidTap: CallBack?
    var tableViewIsEmpty: CallBack?
    
    // MARK: - UIImageView, UIView, UILabel
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.isSkeletonable = true
        return image
    }()


    private let headlinelabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.isSkeletonable = true
        return label
    }()

    private let datetimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        return label
    }()

    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var urlButton: UIButton = {
        let button = UIButton()
        button.setTitle("View on website", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.systemGray3, for: .normal)
        button.addTarget(self, action: #selector(handleOpenUrl), for: .touchUpInside)
        button.isSkeletonable = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
     }

    // MARK: - Setup Constraints

    func configure(with news: News) {
        let url = URL(string: news.image)
        newsImageView.kf.setImage(with: url)
        datetimeLabel.text = "\(news.datetime)"
        sourceLabel.text = news.source
        headlinelabel.text = news.headline
        summaryLabel.text = news.summary
    }
    
    @objc
    func handleOpenUrl() {
        onWebsiteLinkButtonDidTap?()
    }
    
    func setupViews(){
        
        isSkeletonable = true
        contentView.isSkeletonable = true
        selectionStyle = .none
        
        contentView.addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
        
        contentView.addSubview(datetimeLabel)
        datetimeLabel.snp.makeConstraints { make in
            make.left.equalTo(newsImageView.snp.right).offset(15)
            make.centerY.equalTo(newsImageView)
        }

        contentView.addSubview(sourceLabel)
        sourceLabel.snp.makeConstraints { make in
            make.left.equalTo(datetimeLabel.snp.right).offset(10)
            make.centerY.equalTo(newsImageView)
        }

        contentView.addSubview(headlinelabel)
        headlinelabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(10)
            make.left.equalTo(newsImageView.snp.left)
            make.right.equalTo(contentView).offset(-20)
        }

        contentView.addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(headlinelabel.snp.bottom).offset(10)
            make.left.equalTo(newsImageView.snp.left)
            make.right.equalTo(headlinelabel.snp.right)
        }

        contentView.addSubview(urlButton)
        urlButton.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(5)
            make.left.equalTo(newsImageView.snp.left)
            make.bottom.equalTo(contentView).offset(-15)
            make.width.equalTo(105)
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
}
