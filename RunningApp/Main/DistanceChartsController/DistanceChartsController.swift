//
//  DistanceChartsController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/29.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class DistanceChartsController: UIViewController, ChartViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetUp()
    }

    /** 初期設定 */
    private func initSetUp() {
        self.view.layer.cornerRadius = 10.0
        self.view.clipsToBounds = true
        
        let realm = try! Realm()
        let motionDate = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: true)
        
        guard !motionDate.isEmpty else {
            return
        }
        
        let rect = CGRect(x: 0, y: 0 , width: AppSize.width - 20, height: 160)
        let chartView = LineChartView(frame: rect)
        chartView.chartDescription?.text = ""
        
        chartView.xAxis.enabled = false
        
        //        chartView.leftAxis.enabled = false
        //        chartView.rightAxis.enabled = false
        
        var entries = [BarChartDataEntry]()
        var count = 0.0
        
        let roop = motionDate.count >= 15 ? 15 : motionDate.count
        
        for i in 0..<roop {
            entries.append(BarChartDataEntry(x: count, y: Double(motionDate[i].distance)!))
            count += 0.1
        }
        
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        let set = LineChartDataSet(values: entries, label: "走行距離")
        //        set.colors = ChartColorTemplates.vordiplom()
        //        set.colors = ChartColorTemplates.pastel()
        
        //        set.circleColors = ChartColorTemplates.pastel()
        //        set.circleColors = ChartColorTemplates.liberty()
        //        set.circleColors = ChartColorTemplates.material()
        
        chartView.data = LineChartData(dataSet: set)
        self.view.addSubview(chartView)
    }



}
