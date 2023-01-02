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

    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingSubviews()
        self.setCharts(dataPoints: months, values: unitsSold)
    }
    
    private func settingSubviews() {
        self.months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        self.unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        self.barChartView.noDataText = "데이터가 없습니다."
        self.barChartView.noDataFont = .systemFont(ofSize: 20)
        self.barChartView.noDataTextColor = .lightGray
    }
    
    private func setCharts(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "판매량")
        
        // Chart Color
        chartDataSet.colors = [.systemBlue]
        
        chartDataSet.highlightEnabled = false   // 선택 안되게
        
        self.barChartView.doubleTapToZoomEnabled = false // 줌 끄기
        self.barChartView.xAxis.labelPosition = .bottom // X축 레이블 위치 조정
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months) // X축 레이블 포맷 지정
        self.barChartView.xAxis.setLabelCount(dataPoints.count, force: false) // X 축 레이블 최대 개수 지정
        self.barChartView.rightAxis.enabled = false
        self.barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        // Limit Line 추가
        let limitLine = ChartLimitLine(limit: 10.0, label: "Limit")
        limitLine.lineColor = .systemCyan
        self.barChartView.leftAxis.addLimitLine(limitLine)
        
        // 맥시멈, 미니멈
        self.barChartView.leftAxis.axisMaximum = 30
        self.barChartView.leftAxis.axisMinimum = -10
        
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
}

