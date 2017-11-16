
import UIKit
import Charts
import RealmSwift

class MyInfoCharsViewController: UIViewController, ChartViewDelegate, UIScrollViewDelegate {
    
    private var myInfo: Results<RealmDataSet>!
    private var scrollView: UIScrollView!

    var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        myInfo = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        guard !myInfo.isEmpty else { return }
        
        setupScrollView()
        setupPieChart()
        setChart()
        
        self.view.addSubview(scrollView)
    }
    
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: AppSize.statusBarAndNavigationBarHeight + 40, width: AppSize.width, height: AppSize.height))
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: AppSize.width, height: AppSize.height)
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self

    }
    
    private func setupPieChart() {
        let rect = CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height / 2)
        let chartView = PieChartView(frame: rect)

        var runCount = 0
        var walkingCount = 0
        myInfo.forEach { value in
            switch value.workType {
            case "directionsRun":
                runCount += 1
            case "directionsWalking":
                walkingCount += 1
            default: break
            }
        }
        
        let runPercentage = Double(runCount / (runCount + walkingCount) * 100)
        let walkPercentage = Double(walkingCount / (runCount + walkingCount) * 100)

        print(runPercentage)
        print(walkPercentage)

        let entries = [
            PieChartDataEntry(value: runPercentage, label: "Running"),
            PieChartDataEntry(value: walkPercentage, label: "Walking"),
            ]

        let set = PieChartDataSet(values: entries, label: "運動のタイプ")
//        set.entryLabelColor = .red
        set.colors = ChartColorTemplates.colorful()
//        set.valueTextColor = .white
//        set.entryLabelColor = .white
        chartView.data = PieChartData(dataSet: set)
        chartView.chartDescription?.textColor = .white
        chartView.entryLabelColor = .white
        chartView.chartDescription?.text = "運動のタイプ別割合"
        scrollView.addSubview(chartView)
    }
    
    func setChart() {
        
        let rect = CGRect(x: 0, y: AppSize.height / 2 + 50, width: AppSize.width, height: AppSize.height / 2)
        barChartView = BarChartView(frame: rect)
//        barChartView.xAxis.enabled = false
        barChartView.noDataText = "You need to provide data for the chart."

        var dataEntries: [BarChartDataEntry] = []

        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChartView.xAxis.granularity = 1
        
        var distanceArray = [Double]()
        myInfo.forEach { value in
            print(value.date)
            
            var monthDistance = [String: Double]()
            switch value.date {
                case let e where e.contains("2017-01"):
                    monthDistance["Jan"] = Double(value.distance)
                
                case let e where e.contains("2017-02"):
                    monthDistance["Feb"] = Double(value.distance)
                
                case let e where e.contains("2017-03"):
                    monthDistance["Mar"] = Double(value.distance)
                
                case let e where e.contains("2017-04"):
                    monthDistance["Apr"] = Double(value.distance)
                
                case let e where e.contains("2017-05"):
                    monthDistance["May"] = Double(value.distance)
                
                case let e where e.contains("2017-06"):
                    monthDistance["Jun"] = Double(value.distance)
                
                case let e where e.contains("2017-07"):
                    monthDistance["Jul"] = Double(value.distance)
                
                case let e where e.contains("2017-08"):
                        monthDistance["Aug"] = Double(value.distance)
                
                case let e where e.contains("2017-09"):
                    monthDistance["Sep"] = Double(value.distance)
                
                case let e where e.contains("2017-10"):
                    monthDistance["Oct"] = Double(value.distance)
                
                case let e where e.contains("2017-11"):
                    monthDistance["Nov"] = Double(value.distance)
                
                case let e where e.contains("2017-12"):
                    monthDistance["Dec"] = Double(value.distance)
                
                default: break
                
            }
            
            distanceArray.append(monthDistance["Jan"] ?? 0.0)
            distanceArray.append(monthDistance["Feb"] ?? 0.0)
            distanceArray.append(monthDistance["Mar"] ?? 0.0)
            distanceArray.append(monthDistance["Apr"] ?? 0.0)
            distanceArray.append(monthDistance["May"] ?? 0.0)
            distanceArray.append(monthDistance["Jun"] ?? 0.0)
            distanceArray.append(monthDistance["Jul"] ?? 0.0)
            distanceArray.append(monthDistance["Aug"] ?? 0.0)
            distanceArray.append(monthDistance["Sep"] ?? 0.0)
            distanceArray.append(monthDistance["Oct"] ?? 0.0)
            distanceArray.append(monthDistance["Nov"] ?? 0.0)
            distanceArray.append(monthDistance["Dec"] ?? 0.0)

            }
        
        
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: distanceArray[i], data: months as AnyObject )
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "月別ランニング距離")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        scrollView.contentSize.height += barChartView.frame.height - 50
        scrollView.addSubview(barChartView)
    }
    
//    /** 初期設定 */
//    private func initSetup() {
//
//        // Do any additional setup after loading the view.
//        let xArray = Array(1..<10)
//        let ys1 = xArray.map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) }
//        let ys2 = xArray.map { x in return cos(Double(x) / 2.0 / 3.141) }
//
//        let yse1 = ys1.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
//        let yse2 = ys2.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: y) }
//
//        let data = BarChartData()
//        let ds1 = BarChartDataSet(values: yse1, label: "Hello")
//        ds1.colors = [NSUIColor.red]
//        data.addDataSet(ds1)
//
//        let ds2 = BarChartDataSet(values: yse2, label: "World")
//        ds2.colors = [NSUIColor.blue]
//        data.addDataSet(ds2)
//
//        let barWidth = 0.4
//        let barSpace = 0.05
//        let groupSpace = 0.1
//
//        data.barWidth = barWidth
//        self.barChartView.xAxis.axisMinimum = Double(xArray[0])
//        self.barChartView.xAxis.axisMaximum = Double(xArray[0]) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(xArray.count)
//        // (0.4 + 0.05) * 2 (data set count) + 0.1 = 1
//        data.groupBars(fromX: Double(xArray[0]), groupSpace: groupSpace, barSpace: barSpace)
//
//        self.barChartView.data = data
//
//        self.barChartView.gridBackgroundColor = NSUIColor.white
//
//        self.barChartView.chartDescription?.text = "Barchart Demo"
//        self.scrollView.addSubview(barChartView)
//
//    }
    
    
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
