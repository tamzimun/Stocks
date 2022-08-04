//
//  DetailsViewController.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import UIKit
import HGPlaceholders
import SkeletonView
import Charts
import SwiftUI

protocol DetailsViewInput: AnyObject {
    func handleObtainedFilter(_ filter: [FilterEntity])
    func handleObtainedStock(_ stock: Stock)
}

protocol DetailsViewOutput {
    func didLoadView()
    func didSelectFilterCell(with filter: String)
    func didSelectCompanyUrl(with url: String)
}

class DetailsViewController: UIViewController {

    var output: DetailsViewOutput?
    var dataDisplayManager: DetailsDataDisplayManager?
    
    private var candleStickData: [CandleStick] = []
    
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "AAPL"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
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
    
    lazy var lineChart: LineChartView = {
        
        let chartView = LineChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false

        chartView.xAxis.drawGridLinesEnabled = false

        let yAxis = chartView.rightAxis
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        yAxis.enabled = true

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .black

        chartView.animate(xAxisDuration: 0.8)
        chartView.legend.enabled = false

        return chartView
    }()
    
    lazy var candleStickChart: CandleStickChartView = {
        
        let chartView = CandleStickChartView()
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false

        chartView.xAxis.drawGridLinesEnabled = false

        let yAxis = chartView.rightAxis
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = false
        yAxis.enabled = true

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .black

        chartView.animate(xAxisDuration: 0.8)
        chartView.legend.enabled = false

        return chartView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl (items: ["Line","Candle"])
        
        segmented.backgroundColor = UIColor.systemGray6

        segmented.selectedSegmentTintColor = UIColor.black


        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmented.setTitleTextAttributes(titleTextAttributes, for:.normal)

        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmented.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        segmented.frame.size.height = 50.0
        
        let font = UIFont.systemFont(ofSize: 16)
        segmented.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

        segmented.frame = CGRect()
        segmented.selectedSegmentIndex = 0

        segmented.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segmented
    }()
    
    private let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
    
        var collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCollectionViewCell")
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    let companyInfo: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "About company"
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let country: UILabel = {
        let label = UILabel()
        label.text = "Country: US"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let exchange: UILabel = {
        let label = UILabel()
        label.text = "Exchange: NASDAQ/NMS (GLOBAL MARKET)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ipo: UILabel = {
        let label = UILabel()
        label.text = "IPO: 1980-12-12"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let finnhubIndustry: UILabel = {
        let label = UILabel()
        label.text = "Industry: Technology"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weburl: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("More on website", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.systemGray2, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleOpenUrl), for: .touchUpInside)
        button.isSkeletonable = true
        return button
    }()
    
    var webSite: String = ""
    var textNotes: [Int] = []
    var infoLabelChart: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        makeConstraints()
        setUPChartVuew()
        output?.didLoadView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        self.setDataCount(Int(100), range: UInt32(100))
        candleStickChart.isHidden = true
        self.setLineChart()
    }
    
    @objc
    func handleOpenUrl() {
        output?.didSelectCompanyUrl(with: webSite)
    }
    
    func setUPChartVuew() {
        lineChart.delegate = self
    }
    
    var entities: [ChartDataEntry] = [
        ChartDataEntry(x: 1572566400, y: 129.4534),
        ChartDataEntry(x: 1572825600, y: 131.4974),
        ChartDataEntry(x: 1572912000, y: 131.7076),
        ChartDataEntry(x: 1572998400, y: 132.5577),
        ChartDataEntry(x: 1573084800, y: 131.5165),
        ChartDataEntry(x: 1573171200, y: 131.4401),
        ChartDataEntry(x: 1573430400, y: 129.3961),
        ChartDataEntry(x: 1573516800, y: 129.5107),
        ChartDataEntry(x: 1573603200, y: 128.4504),
        ChartDataEntry(x: 1573776000, y: 128.374),
        ChartDataEntry(x: 1574035200, y: 128.2881),
        ChartDataEntry(x: 1574121600, y: 128.4887),
        ChartDataEntry(x: 1574208000, y: 127.2278),
        ChartDataEntry(x: 1574294400, y: 127.8392),
        ChartDataEntry(x: 1574380800, y: 128.3167),
        ChartDataEntry(x: 1574640000, y: 129.8736),
        ChartDataEntry(x: 1574726400, y: 129.0331),
        ChartDataEntry(x: 1574812800, y: 127.7723),
        ChartDataEntry(x: 1574985600, y: 128.4218),
    ]
    
    func setLineChart() {
        
        
    //        let new = ViewModelDataEntries(x: viewModel.data, y: viewModel.timeInterval)
    //        for (index) in new.x.indices {
    //            entries.append(ChartDataEntry(x: new.y[index], y: new.x[index]))
    //        }
        
        
        let gradientColors = [UIColor.black.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        
        let dataSet = LineChartDataSet(entries: entities)
        dataSet.colors = ChartColorTemplates.liberty()
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        dataSet.fillAlpha = 0.2
        dataSet.drawFilledEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 3
        dataSet.mode = .cubicBezier

        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        
        lineChart.setVisibleXRangeMaximum(1400000)
        lineChart.moveViewToX(Double(entities.count - 1))

        lineChart.data = data
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(40) + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0
            
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "default.jpeg")!)
        }
        
        let set1 = CandleChartDataSet(entries: yVals1)
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false
        
        let data = CandleChartData(dataSet: set1)
        candleStickChart.data = data
    }
    
    @objc
    func segmentAction(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            view.backgroundColor = .white
//            lineChart.isHidden = false
//            candleStickChart.isHidden = true
        case 1:
            view.backgroundColor = .white
//            lineChart.isHidden = true
//            candleStickChart.isHidden = false
        default:
            break
        }
    }
    
    private func setUpViews() {
        
        dataDisplayManager?.onFilterDidSelect = { [ weak self] filter in
            self?.output?.didSelectFilterCell(with: filter)
        }
        filterCollectionView.delegate = dataDisplayManager
        filterCollectionView.dataSource = dataDisplayManager
    }
    
    private func makeConstraints() {
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(35)
        }
        
        view.addSubview(tickerLabel)
        tickerLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        view.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(tickerLabel.snp.bottom).offset(2)
            make.left.equalTo(tickerLabel.snp.left)
        }
        
        view.addSubview(priceChangeLabel)
        priceChangeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.left.equalTo(tickerLabel.snp.left)
        }
        
        view.addSubview(lineChart)
        lineChart.snp.makeConstraints { make in
            make.top.equalTo(priceChangeLabel.snp.bottom).offset(-10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(400)
        }
        
        view.addSubview(candleStickChart)
        candleStickChart.snp.makeConstraints { make in
            make.top.equalTo(priceChangeLabel.snp.bottom).offset(-10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(400)
        }
        
        view.addSubview(filterCollectionView)
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(lineChart.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        view.addSubview(companyInfo)
        companyInfo.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(15)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(country)
        country.snp.makeConstraints { make in
            make.top.equalTo(companyInfo.snp.bottom).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }

        view.addSubview(exchange)
        exchange.snp.makeConstraints { make in
            make.top.equalTo(country.snp.bottom).offset(5)
            make.left.equalTo(country.snp.left)
            make.right.equalTo(country.snp.right)
        }
        
        view.addSubview(ipo)
        ipo.snp.makeConstraints { make in
            make.top.equalTo(exchange.snp.bottom).offset(5)
            make.left.equalTo(country.snp.left)
            make.right.equalTo(country.snp.right)
        }
        
        view.addSubview(finnhubIndustry)
        finnhubIndustry.snp.makeConstraints { make in
            make.top.equalTo(ipo.snp.bottom).offset(5)
            make.left.equalTo(country.snp.left)
            make.right.equalTo(country.snp.right)
        }

        view.addSubview(weburl)
        weburl.snp.makeConstraints { make in
            make.top.equalTo(finnhubIndustry.snp.bottom).offset(5)
            make.left.equalTo(country.snp.left)
            make.right.equalTo(country.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-25)
        }
    }
}

extension DetailsViewController: DetailsViewInput {
    
    func handleObtainedStock(_ stock: Stock) {
        self.tickerLabel.text = stock.profile?.ticker
        self.priceLabel.text = "$\(stock.quote?.c ?? 0)"
        self.priceChangeLabel.text =  "\(stock.quote?.d ?? 0) \(stock.quote?.dp ?? 0)%"
        
        // Coloring price
        guard let priceChange = stock.quote?.d else { return }
        if priceChange < 0 {
            priceChangeLabel.textColor = .red
        }
        
        self.title = stock.profile?.name
        self.country.text = "Country: \(stock.profile!.country)"
        self.exchange.text = "Exchange: \(stock.profile!.exchange)"
        self.ipo.text = "IPO: \(stock.profile!.ipo)"
        self.finnhubIndustry.text = "Industry: \(stock.profile!.finnhubIndustry)"
        self.webSite = stock.profile!.weburl
    }
    
    func handleObtainedFilter(_ filter: [FilterEntity]) {
        dataDisplayManager?.filter = filter
        filterCollectionView.reloadData()
        
        // select first item of collection view, when categories are loaded
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        filterCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
}

extension DetailsViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("MY POINTS ARE \(entry)")
        let pos = NSInteger(entry.y)
        infoLabelChart.text = "\(pos)"
    }
}

