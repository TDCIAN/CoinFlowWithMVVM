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
    
    var coinInfo: CoinInfo!
    var chartDatas: [CoinChartInfo] = []
    var selectedPeriod: Period = .day
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateCoinInfo(coinInfo)
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("--> 꽂힌 정보 확인 => 키: \(coinInfo.key), 밸류: \(coinInfo.value)")
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
        // 정보를 다 받아온다 (day, week, month, year)
        // 어느 데이터가 먼저 오는지 알 수가 없다
        // day는 반드시 먼저 와야된다 -> 그리기 전에 4가지 데이터를 다 갖고 와야 될 것 같다
        // 그러면, 4개가 언제 다 들어올지 모르는 상황이다
        // 네 개가 다 들어오고, 그 다음에 차트를 렌더하자
        
        // 디스패치 그룹에서 작업들이 시작할 때 해당 그룹에 들어간다(피리어드가 4개니까 네 번 들어감)
        // 리스폰스가 오는 시점에 그룹에서 떠난다
        // 다 떠나고 나면 노티파이가 실행된다
        let dispatchGroup = DispatchGroup()
        
        Period.allCases.forEach { period in
            dispatchGroup.enter()
            NetworkManager.requestCoinChartData(coinType: coinInfo.key, period: period) { result in
                dispatchGroup.leave()
                switch result {
                case .success(let coinChartDatas):
    //                print("--> 코인차트데이터: \(coinChartDatas)")
                    self.chartDatas.append(CoinChartInfo(key: period, value: coinChartDatas))
                case .failure(let error):
                    print("--> 코인차트데이터에러: \(error.localizedDescription)")
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            // -> 차트를 렌더한다
            print("render chart... \(self.chartDatas.count)")
            self.renderChart(with: self.selectedPeriod)
        }


    }
    

    

    
    private func renderChart(with period: Period) {
        print("rendering... \(period)")
        // 데이터 가져오기
        // 차트에 필요한 차트데이터 가공
        // 차트에 적용
        
        // (1) 데이터 가져오기
        guard let coinChartData = chartDatas.first(where: { $0.key == period })?.value else { return }
        
        // (2) 차트에 필요한 차트데이터 가공
        let chartDataEntry = coinChartData.map { chartData -> ChartDataEntry in
            let time = chartData.time
            let price = chartData.closePrice
            return ChartDataEntry(x: time, y: price)
        }
        
        // (3) 차트에 적용
        // Configure Dataset(how to draw)
        let lineChartDataSet = LineChartDataSet(entries: chartDataEntry, label: "Coin Value")
        
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
//        chartView.data = data
        
    }

    private func moveHighlightBar(to button: UIButton) {
        highlightBarLeading.constant = button.frame.minX
    }
    
    private func updateCoinInfo(_ coinInfo: CoinInfo) {
        coinTypeLabel.text = "\(coinInfo.key)"
        currentPriceLabel.text = String(format: "%.1f", coinInfo.value.usd.price)
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
