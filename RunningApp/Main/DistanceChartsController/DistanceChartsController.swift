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
        
        let realm = try! Realm()
        let motionDate = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)

        var rect = CGRect(x: 0, y: 0, width: AppSize.width - 30, height: 130)
        rect.origin.y += 20
        rect.size.height -= 20
        
        let chartView = LineChartView(frame: rect)
        chartView.chartDescription?.text = ""
        
//        chartView.xAxis.enabled = false
//        chartView.leftAxis.enabled = false
//        chartView.rightAxis.enabled = false
        
        var entries = [BarChartDataEntry]()
        var count = 0.0
        motionDate.forEach { (date) in
            entries.append(BarChartDataEntry(x: Double(count), y: Double(date.distance)!))
            count += 0.1
        }
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        let set = LineChartDataSet(values: entries, label: "走行距離")
        set.colors = ChartColorTemplates.vordiplom()
        chartView.data = LineChartData(dataSet: set)
        self.view.addSubview(chartView)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
