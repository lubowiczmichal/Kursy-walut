//
//  CurrencyDetailsViewController.swift
//  Kursy walut
//
//  Created by Michał Lubowicz on 30/06/2021.
//

import UIKit

class CurrencyDetailsViewController: UIViewController {
    
    var currencyDetailsViewModel : CurrencyDetailsViewModel?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let refresh: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        } else {
            button.setImage(UIImage(named: "arrow.clockwise"), for: .normal)
        }
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(reloadButtonCliced), for: .touchUpInside)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()

    private let startDateLabel: UILabel = {
       let label = UILabel()
        label.text = "Od dnia "
        return label
    }()
    
    private let endDateLabel: UILabel = {
       let label = UILabel()
        label.text = "Do dnia "
        return label
    }()
       
    
    var startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.date = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        picker.addTarget(self, action: #selector(CurrencyDetailsViewController.startDatePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    var endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.addTarget(self, action: #selector(CurrencyDetailsViewController.endDatePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    var textLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .systemBlue
        spinner.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            spinner.backgroundColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .black
                default:
                    return .white
                }
            }
        } else {
            spinner.backgroundColor = .white
        }
        return spinner
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .black
                default:
                    return .white
                }
            }
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(textLabel)
        view.addSubview(startDateLabel)
        view.addSubview(endDateLabel)
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.addSubview(refresh)
        tableView.delegate = self
        tableView.dataSource = self
        endDatePicker.minimumDate = currencyDetailsViewModel?.startDate
        currencyDetailsViewModel?.spinnerAndLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        startDatePicker.frame = CGRect(x: 80, y: 200, width: 300, height: 30)
        endDatePicker.frame = CGRect(x: 80, y: 250, width: 300, height: 30)
        startDateLabel.frame = CGRect(x: 10, y: 200, width: 150, height: 30)
        endDateLabel.frame = CGRect(x: 10, y: 250, width: 60, height: 30)
        tableView.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 350)
        textLabel.frame = CGRect(x: 10, y: 80, width: UIScreen.main.bounds.width - 20, height: 120)
        refresh.frame = CGRect(x: UIScreen.main.bounds.width - 40, y: 60, width: 30, height: 30)
        
    }
    
    @objc func reloadButtonCliced(_ sender:UIButton!)
    {
        UIView.animate(withDuration: 0.5) {
        self.refresh.transform = self.refresh.transform.rotated(by: CGFloat.pi)
        }
        UIView.animate(withDuration: 0.5) {
            self.refresh.transform = self.refresh.transform.rotated(by: CGFloat.pi)
        }
        DispatchQueue.main.async {
            self.currencyDetailsViewModel?.spinnerAndLoad()
        }
    }
    
    @objc func startDatePickerValueChanged(_ sender: UIDatePicker){
        
        currencyDetailsViewModel?.startDate = sender.date
        endDatePicker.minimumDate = currencyDetailsViewModel?.startDate
        endDatePicker.maximumDate = min(Date(), Calendar.current.date(byAdding: .day, value: 93, to: currencyDetailsViewModel?.startDate ?? Date())!)
    }
    
    @objc func endDatePickerValueChanged(_ sender: UIDatePicker){
        currencyDetailsViewModel?.endDate = sender.date
    }
    

    
}

extension CurrencyDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyDetailsViewModel!.nbpData?.rates.count
            ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
        cell?.textLabel?.text = "Kurs z dnia " + currencyDetailsViewModel!.nbpData!.rates[indexPath.row].effectiveDate! + ": " + String(format: "%.4f",currencyDetailsViewModel!.nbpData!.rates[indexPath.row].mid ?? (currencyDetailsViewModel!.nbpData!.rates[indexPath.row].ask! + currencyDetailsViewModel!.nbpData!.rates[indexPath.row].bid!)/2) + " PLN"
        return cell!
    }
    
    
}
