//
//  ViewController.swift
//  ChartsApp
//
//  Created by Conner on 2023/01/02.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    var months: [String]!
    var unitsSold: [Double]!
    
    //
    var combinedGraphArray: [String]!
    var combinedBarUnitsSold: [Double]!
    var combinedLineUnitsSold: [Double]!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var combinedChartView: CombinedChartView!
    
    private var customMarkerView = CustomMarkerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingSubviews()
        
        self.setBarChartData()
        self.setBarChartView(dataPoints: months, values: unitsSold)
        
        self.setCombineChartData()
        self.setCombinedCartView(dataPoints: self.combinedGraphArray, barValues: self.combinedBarUnitsSold, lineValues: self.combinedLineUnitsSold)
    }
    
    private func settingSubviews() {
        self.barChartView.noDataText = "데이터가 없습니다."
        self.barChartView.noDataFont = .systemFont(ofSize: 20)
        self.barChartView.noDataTextColor = .lightGray
        self.barChartView.backgroundColor = .white
    }
    
    // MARK: Bar Chart
    private func setBarChartData() {
        self.months = ["Jan", "Feb"]
        //        self.months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        self.unitsSold = [20.0, 4.0]
        //        self.unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    }
    
    private func setBarChartView(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i + 3), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "판매량")
        
        // Chart Color
        chartDataSet.colors = [.systemBlue]
        
//        chartDataSet.highlightEnabled = false   // 선택 안되게
        
        self.barChartView.barData?.barWidth = 10.0
        self.barChartView.fitBars = true
        self.barChartView.doubleTapToZoomEnabled = false // 줌 끄기
        self.barChartView.xAxis.labelPosition = .bottom // X축 레이블 위치 조정
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months) // X축 레이블 포맷 지정
        self.barChartView.xAxis.setLabelCount(dataPoints.count * 4, force: false) // X 축 레이블 최대 개수 지정
        self.barChartView.rightAxis.enabled = false
        self.barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // Limit Line 추가
        let limitLine = ChartLimitLine(limit: 10.0, label: "Limit")
        limitLine.lineColor = .systemCyan
        self.barChartView.leftAxis.addLimitLine(limitLine)
        
        // 맥시멈, 미니멈
        self.barChartView.leftAxis.axisMaximum = 30
        self.barChartView.leftAxis.axisMinimum = -10
        
        self.barChartView.xAxis.axisMaximum = 7
        self.barChartView.xAxis.axisMinimum = 0
        
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = 0.8
        barChartView.data = chartData
        
        self.customMarkerView.chartView = barChartView
        barChartView.marker = self.customMarkerView
        barChartView.delegate = self
    }
    
    // MARK: Combined Chart
    private func setCombineChartData() {
        self.combinedGraphArray = ["09시", "10시", "11시", "12시", "13시", "14시", "15시", "16시", "17시", "18시"]
        
        self.combinedBarUnitsSold = [10.0, 17.0, 9.0, 1.0, 8.0, 13.0, 16.0, 14.0, 7.0, 1.0]
        self.combinedLineUnitsSold = [10.0, 18.0, 7.0, 1.0, 5.0, 15.0, 14.0, 17.0, 7.0, 1.0]
    }
    
    private func setCombinedCartView(dataPoints: [String], barValues: [Double], lineValues: [Double]) {
        var barDataEntries: [BarChartDataEntry] = []
        var lineDataEntries: [ChartDataEntry] = []
        
        // bar, line 엔트리 삽입
        for i in 0..<dataPoints.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), y: barValues[i])
            let lineDataEntry = ChartDataEntry(x: Double(i), y: lineValues[i])
            barDataEntries.append(barDataEntry)
            lineDataEntries.append(lineDataEntry)
        }
        
        // 데이터셋 생성
        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "목표처리량")
        let lineChartDataSet = LineChartDataSet(entries: lineDataEntries, label: "실시간 처리량")
        
        // 라인 속성 지정
        lineChartDataSet.colors = [.red]
        lineChartDataSet.circleColors = [.red]
        lineChartDataSet.lineWidth = 5.0
        
        
        let combinedData: CombinedChartData = CombinedChartData()
        
        combinedData.barData = BarChartData(dataSet: barChartDataSet)
        combinedData.lineData = LineChartData(dataSet: lineChartDataSet)
        
        combinedData.isHighlightEnabled = false
        self.combinedChartView.data = combinedData
        self.combinedChartView.doubleTapToZoomEnabled = false
        self.combinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
    }
}


extension ViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("char Value selected")
        if chartView == self.barChartView {
            guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else {
                return
            }
            
            let entryIndex = dataSet.entryIndex(entry: entry)
            print(entry)
            print(self.months[entryIndex])
            self.customMarkerView.setMarkerValue(title: self.months[entryIndex], value: "\(self.unitsSold[entryIndex])")
        }
    }
}
