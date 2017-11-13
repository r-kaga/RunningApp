//
//  MyPageChartsViewController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/11/12.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class MyPageChartsViewController: UIViewController, ChartViewDelegate {

    let barChartView: barChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    
    /** 初期設定 */
    private func initSetup() {
//        self.view.layer.cornerRadius = 10.0
//        self.view.clipsToBounds = true
        
//        let realm = try! Realm()
//        let motionDate = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: true)
//
//        guard !motionDate.isEmpty else {
//            return
//        }
//
//        let rect = CGRect(x: 0, y: 0 , width: AppSize.width / 2, height: AppSize.height / 4)
//        let chartView = LineChartView(frame: rect)
//        chartView.chartDescription?.text = ""
//
//        chartView.xAxis.enabled = false
//
//        //        chartView.leftAxis.enabled = false
//        //        chartView.rightAxis.enabled = false
//
//        var entries = [BarChartDataEntry]()
//        var count = 0.0
//
//        let roop = motionDate.count >= 15 ? 15 : motionDate.count
//
//        for i in 0..<roop {
//            entries.append(BarChartDataEntry(x: count, y: Double(motionDate[i].distance)!))
//            count += 0.1
//        }
        



        // Do any additional setup after loading the view.
        let xArray = Array(1..<10)
        let ys1 = xArray.map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) }
        let ys2 = xArray.map { x in return cos(Double(x) / 2.0 / 3.141) }

        let yse1 = ys1.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
        let yse2 = ys2.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }

        let data = BarChartData()
        let ds1 = BarChartDataSet(values: yse1, label: "Hello")
        ds1.colors = [NSUIColor.red]
        data.addDataSet(ds1)

        let ds2 = BarChartDataSet(values: yse2, label: "World")
        ds2.colors = [NSUIColor.blue]
        data.addDataSet(ds2)

        let barWidth = 0.4
        let barSpace = 0.05
        let groupSpace = 0.1

        data.barWidth = barWidth
        self.barChartView.xAxis.axisMinimum = Double(xArray[0])
        self.barChartView.xAxis.axisMaximum = Double(xArray[0]) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(xArray.count)
        // (0.4 + 0.05) * 2 (data set count) + 0.1 = 1
        data.groupBars(fromX: Double(xArray[0]), groupSpace: groupSpace, barSpace: barSpace)

        self.barChartView.data = data

        self.barChartView.gridBackgroundColor = NSUIColor.white

        self.barChartView.chartDescription?.text = "Barchart Demo"
        self.view.addSubview(barChartView)

        
//        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//
//        let set = BarChartDataSet(values: entries, label: "走行距離")
//
//        chartView.data = BarChartData(dataSet: set)
//        self.view.addSubview(chartView)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
