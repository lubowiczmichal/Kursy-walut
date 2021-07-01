//
//  CurrenciesListViewController.swift
//  Kursy walut
//
//  Created by Michał Lubowicz on 30/06/2021.
//

import UIKit

class CurrenciesListViewController: UIViewController{
    
    var currienciesListViewModel: CurrenciesListViewModel?
    
    let refresh: UIButton = {
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Kursy walut NBP"
        label.font = UIFont.italicSystemFont(ofSize: 20)
        return label
    }()
    
    let parametrLabel: UILabel = {
        let label = UILabel()
        label.text = "Wybierz tabele danych"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.rowHeight = 60
        return tableView
    }()
    
    let typePickerView: UIPickerView = UIPickerView()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .systemBlue
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
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
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
        tableView.delegate = self
        tableView.dataSource = self
        typePickerView.delegate = self
        typePickerView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(spinner)
        view.addSubview(refresh)
        view.addSubview(titleLabel)
        view.addSubview(typePickerView)
        view.addSubview(parametrLabel)
        currienciesListViewModel = CurrenciesListViewModel(currenciesList: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        titleLabel.frame = CGRect(x: 10, y: 20, width: 200, height: 50)
        typePickerView.frame = CGRect(x: 175, y: 50, width: 80, height: 40)
        parametrLabel.frame = CGRect(x: 15, y: 50, width: 200, height: 40)
        refresh.frame = CGRect(x: UIScreen.main.bounds.width - 40, y: 30, width: 30, height: 30)
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
            self.currienciesListViewModel?.spinnerAndLoad()
        }
    }
    
    
}

extension CurrenciesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currienciesListViewModel?.nbpData?[0].rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier,for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        cell.config(code: currienciesListViewModel!.nbpData![0].rates[indexPath.row].code!, fullName: currienciesListViewModel!.nbpData![0].rates[indexPath.row].currency! ,rate: Float(currienciesListViewModel!.nbpData![0].rates[indexPath.row].mid ?? (currienciesListViewModel!.nbpData![0].rates[indexPath.row].ask! + currienciesListViewModel!.nbpData![0].rates[indexPath.row].bid!)/2), date: currienciesListViewModel!.nbpData![0].effectiveDate!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currienciesListViewModel?.showCurrencyDetails(selected: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension CurrenciesListViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currienciesListViewModel?.pickerDataSource.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currienciesListViewModel?.pickerDataSource[row]
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currienciesListViewModel?.selected = (currienciesListViewModel?.pickerDataSource[row])!
        self.currienciesListViewModel?.spinnerAndLoad()
    }
    
}
