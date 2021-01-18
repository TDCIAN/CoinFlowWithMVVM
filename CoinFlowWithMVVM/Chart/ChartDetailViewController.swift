//
//  ChartDetailViewController.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/03.
//

import UIKit
import Charts

typealias CoinChartInfo = (key: Period, value: [ChartData])

class ChartDetailViewController: UIViewController {

//    var coinInfo: CoinInfo!
//    var chartDatas: [CoinChartInfo] = []
//    var selectedPeriod: Period = .day
    
    @IBOutlet weak var coinTypeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var highlightBar: UIView!
    @IBOutlet weak var highlightBarLeading: NSLayoutConstraint!
    
    @IBOutlet weak var chartView: LineChartView!
    
    var viewModel: ChartDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateCoinInfo(coinInfo)
        updateCoinInfo(viewModel)
        fetchData()
    }
    
    @IBAction func dailyButtonTapped(_ sender: UIButton) {
        renderChart(with: .day)
        moveHighlightBar(to: sender)
    }
    
    @IBAction func weeklyButtonTapped(_ sender: UIButton) {
        renderChart(with: .week)
        moveHighlightBar(to: sender)
    }
    
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        renderChart(with: .month)
        moveHighlightBar(to: sender)
    }
    
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        renderChart(with: .year)
        moveHighlightBar(to: sender)
    }
}

extension ChartDetailViewController {
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        Period.allCases.forEach { period in
            dispatchGroup.enter()
            NetworkManager.requestCoinChartData(coinType: coinInfo.key, period: period) { (result: Result<[ChartData], Error>) in
                dispatchGroup.leave()
                switch result {
                case .success(let chartDatas):
                    self.chartDatas.append(CoinChartInfo(key: period, value: chartDatas))
                    print("--> success:\(chartDatas.count), \(period)")
                case .failure(let error):
                    print("--> err: \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // update chart
            print("update chart")
            // render chart view
            self.renderChart(with: self.selectedPeriod)
        }
    }
    
    private func renderChart(with period: Period) {
        print("rendering... \(period) ")
        // 데이터 가져오기
        // 차트에 필요한 차트데이터 가공
        // 차트에 적용
        
        
        // 데이터 가져오기
        guard let coinChartData = chartDatas.first(where: { $0.key == period })?.value else { return }
        // 차트에 필요한 차트데이터 가공
        
        print("코인차트데이터: \(coinChartData)")
        let chartDataEntry = coinChartData.map { chartData -> ChartDataEntry in
            let time = chartData.time
            let price = chartData.closePrice
            return ChartDataEntry(x: time, y: price)
        }
        print("차트데이터 엔트리: \(chartDataEntry)")
        // 차트에 적용
        
        // Configure Dataset(how to draw)
        let lineChartDataSet = LineChartDataSet(entries: chartDataEntry, label: "Coin Value")
        print("라인차트데이터셋: \(lineChartDataSet)")
        // -- draw mode
        lineChartDataSet.mode = .horizontalBezier
        // -- color
        lineChartDataSet.colors = [UIColor.systemBlue]
        // -- draw circle
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawCircleHoleEnabled = false
        // -- draw y value
        lineChartDataSet.drawValuesEnabled = false
        // -- highlight when user touch
        lineChartDataSet.highlightEnabled = true
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.highlightColor = UIColor.systemBlue

        // LineChartDataSet, [ChartDataEntry]
        
        let data = LineChartData(dataSet: lineChartDataSet)
        chartView.data = data
        
        // Gradient fill
        let startColor = UIColor.systemBlue
        let endColor = UIColor(white: 1, alpha: 0.3)
        
        let gradientColors = [startColor.cgColor, endColor.cgColor] as CFArray // Colors of the gradient
        let colorLocations: [CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        lineChartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        // Axis - xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = xAxisDateFormatter(period: period)
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = true
        xAxis.drawLabelsEnabled = true
        
        // Axis - yAxis
        let leftYAxis = chartView.leftAxis
        leftYAxis.drawGridLinesEnabled = false
        leftYAxis.drawAxisLineEnabled = false
        leftYAxis.drawLabelsEnabled = false
        
        let rightYAxis = chartView.rightAxis
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawAxisLineEnabled = false
        rightYAxis.drawLabelsEnabled = false
        
        // User InterAction
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = true
        
        chartView.delegate = self

        // Chart Description
        let description = Description()
        description.text = ""
        chartView.chartDescription = description
        
        // Legend
        let legend = chartView.legend
        legend.enabled = false
        
//        // Highest, Lowest Value
//        if let max = chartView.data?.yMax {
//            highestValue.text = "max. \(max.stringFormat)"
//        } else {
//            highestValue.text = ""
//        }
//
//        if let min = chartView.data?.yMin {
//            lowestValue.text = "min. \(min.stringFormat)"
//        } else {
//            lowestValue.text = ""
//        }
        
    } // MARK: 여기까지 렌더차트
    
    private func moveHighlightBar(to button: UIButton) {
        print("--> \(button.frame.minX)")
        highlightBarLeading.constant = button.frame.minX
    }
    
//    private func updateCoinInfo(_ info: CoinInfo) {
//        coinTypeLabel.text = "\(info.key)"
//        currentPriceLabel.text = String(format: "%.1f", info.value.usd.price)
//    }
    
    private func updateCoinInfo(_ viewModel: ChartDetailViewModel) {
        coinTypeLabel.text = "\(viewModel.coinInfo.key)"
        currentPriceLabel.text = String(format: "%.1f", viewModel.coinInfo.value.usd.price)
    }
}

extension ChartDetailViewController {
    private func xAxisDateFormatter(period: Period) -> IAxisValueFormatter {
        switch period {
        case .day: return ChartXAxisDayFormatter()
        case .week: return ChartXAxisWeekFormatter()
        case .month: return ChartXAxisMonthFormatter()
        case .year: return ChartXAxisYearFormatter()
        }
    }
}

extension ChartDetailViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(#function, entry.x, entry.y, highlight)
        currentPriceLabel.text = String(format: "%.1f", entry.y)
    }
}


class ChartDetailViewModel {
    typealias Handler = ([CoinChartInfo], Period) -> Void
    var changeHandler: Handler
        
    var coinInfo: CoinInfo!
    var chartDatas: [CoinChartInfo] = []
    var selectedPeriod: Period = .day
    
    init(coinInfo: CoinInfo, chartDatas: [CoinChartInfo], selectedPeriod: Period, changeHandler: @escaping Handler) {
        self.coinInfo = coinInfo
        self.chartDatas = chartDatas
        self.selectedPeriod = selectedPeriod
        self.changeHandler = changeHandler
    }
}

extension ChartDetailViewModel {
    
}
