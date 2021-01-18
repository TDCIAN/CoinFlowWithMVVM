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
    
    @IBOutlet weak var coinTypeLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var highlightBar: UIView!
    @IBOutlet weak var highlightBarLeading: NSLayoutConstraint!
    
    @IBOutlet weak var chartView: LineChartView!
    
    var viewModel: ChartDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateCoinInfo(viewModel)
        // -> changeHandler에 대한 업데이트
        viewModel.updateNotify { (chartDatas, selectedPeriod) in
            self.renderChart(with: chartDatas, period: selectedPeriod)
        }
        
        viewModel.fetchData()
    }
    
    @IBAction func dailyButtonTapped(_ sender: UIButton) {
        viewModel.selectedPeriod = .day
        let datas = viewModel.chartDatas
        let selectedPeriod = viewModel.selectedPeriod
        renderChart(with: datas, period: selectedPeriod)
        moveHighlightBar(to: sender)
    }
    
    @IBAction func weeklyButtonTapped(_ sender: UIButton) {
        viewModel.selectedPeriod = .week
        let datas = viewModel.chartDatas
        let selectedPeriod = viewModel.selectedPeriod
        renderChart(with: datas, period: selectedPeriod)
        moveHighlightBar(to: sender)
    }
    
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
//        renderChart(with: .month)
        viewModel.selectedPeriod = .month
        let datas = viewModel.chartDatas
        let selectedPeriod = viewModel.selectedPeriod
        renderChart(with: datas, period: selectedPeriod)
        moveHighlightBar(to: sender)
    }
    
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
//        renderChart(with: .year)
        viewModel.selectedPeriod = .year
        let datas = viewModel.chartDatas
        let selectedPeriod = viewModel.selectedPeriod
        renderChart(with: datas, period: selectedPeriod)
        moveHighlightBar(to: sender)
    }
}

extension ChartDetailViewController {
    
    private func renderChart(with chartDatas: [CoinChartInfo], period: Period) {
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
        
    } // MARK: 여기까지 렌더차트
    
    private func moveHighlightBar(to button: UIButton) {
        print("--> \(button.frame.minX)")
        highlightBarLeading.constant = button.frame.minX
    }

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


