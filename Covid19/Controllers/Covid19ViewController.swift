//
//  ViewController.swift
//  Covid19
//
//  Created by curry敏 on 2021/7/20.
//

import UIKit
import SDWebImage
import Charts

class Covid19ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet weak var todayCaesLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    @IBOutlet weak var todayCaseView: UIView!
    @IBOutlet weak var totalCasesView: UIView!
    @IBOutlet weak var todayDeathsView: UIView!
    @IBOutlet weak var totalDeathsView: UIView!
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var todayDeathsLabel: UILabel!
    @IBOutlet weak var countryID: UILabel!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var lineChart: LineChartView!
    
    var covid19Manager = Covid19Manager()
    var timeSeriesManager = TimeSeriesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        let image = UIImage(systemName: "magnifyingglass")
        imageView.image = image
        imageView.tintColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        
        searchTextField.delegate = self
        covid19Manager.delegate = self
        timeSeriesManager.delegate = self
        
        viewDesign(view: todayCaseView)
        viewDesign(view: totalCasesView)
        viewDesign(view: todayDeathsView)
        viewDesign(view: totalDeathsView)
        viewDesign(view: lineChart)
        //viewDesign(view: idView)
        lineChart.backgroundColor = UIColor.white
        
        //MARK: - search Text Field
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search a country", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        searchTextField.leftViewMode = .always
        searchTextField.leftView = imageView
    }
    
    //MARK: - Search Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let country = searchTextField.text {
            covid19Manager.fetchData(country)
            timeSeriesManager.fetchTimeSeriesData(country)
            print("\(country) is what you typed")
        }
        searchTextField.text = ""
    }
    
    //MARK: - View Design
    func viewDesign(view: UIView) {
        view.layer.cornerRadius = view.layer.frame.size.height / 15
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        view.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        //view.layer.shadowColor = #colorLiteral(red: 0.8928110003, green: 0.1367270052, blue: 0.2764109969, alpha: 1)
        view.layer.shadowOffset = .zero
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
}

//MARK: - Covid19 Manager Delegate
extension Covid19ViewController: Covid19ManagerDelegate {
    func updateData(covid: Covid19Model) {
        DispatchQueue.main.async {
            self.todayCaesLabel.text = String(covid.todayCinModel)
            self.totalCasesLabel.text = String(covid.totalCinModel)
            self.todayDeathsLabel.text = String(covid.todayDinModel)
            self.totalDeathsLabel.text = String(covid.totoalDinModel)
            self.countryID.text = covid.idinModel
            self.countryFlag.sd_setImage(with: URL(string: covid.countryFlag))
        }
    }
}

extension Covid19ViewController: TimeSeriesManagerDelegate {
    
    func updateGraph(time: TimeSeriesModel) {
        
        var lineChartEntry = [ChartDataEntry]()
                
        for i in 0..<time.cases.count {
            
            let value = ChartDataEntry(x: Double(i+1), y: Double(time.cases[i]))
            lineChartEntry.append(value)
            print(value)
        }
        
        let line = LineChartDataSet(entries: lineChartEntry)
        line.colors = [NSUIColor.init(displayP3Red: 0.8928110003, green: 0.1367270052, blue: 0.2764109969, alpha: 1)]
        line.setCircleColor(NSUIColor.init(displayP3Red: 0.8928110003, green: 0.1367270052, blue: 0.2764109969, alpha: 1))
        line.circleHoleColor = UIColor.white
        line.circleRadius = 1.0
        
        let gradientColors = [UIColor.init(displayP3Red: 0.8928110003, green: 0.1367270052, blue: 0.2764109969, alpha: 1).cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocation: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocation) else {
            print("gradient eroor")
            return
        }
        line.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line.drawFilledEnabled = true
        
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.legend.enabled = false
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.leftAxis.drawAxisLineEnabled = false
        
        let data = LineChartData()
        data.addDataSet(line)
        //data.setDrawValues(false)
        
        
        DispatchQueue.main.async {
            print("Graph should change by now!!!")
            //self.lineChart.backgroundColor = UIColor.white
            self.lineChart.data = data
            self.lineChart.chartDescription?.text = "Last 7 Days Data"
        }
        
    }
    
}

