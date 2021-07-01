//
//  CurrenciesListViewModel.swift
//  Kursy walut
//
//  Created by Michał Lubowicz on 30/06/2021.
//

import Foundation
import UIKit

class CurrenciesListViewModel{
    
    var nbpData: NBPData?
    
    var currenciesListViewController: CurrenciesListViewController
    
    let pickerDataSource = ["A","B","C"]
    var selected: String = "A"
    
    init(currenciesList: CurrenciesListViewController) {
        currenciesListViewController = currenciesList
        spinnerAndLoad()
    }
    
    func spinnerAndLoad(){
        currenciesListViewController.spinner.startAnimating()
        DispatchQueue.main.async {
            self.load()
        }
    }
    
    
    func load() {
        let dataToParse = Api.request(url:"https://api.nbp.pl/api/exchangerates/tables/"+self.selected)
        self.parse(json: dataToParse)
    }
    
    func parse(json: Data) {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .background).async {

            let decoder = JSONDecoder()
            do {
                self.nbpData = try decoder.decode(NBPData.self, from: json)
            } catch {
                print(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
        DispatchQueue.main.async {
            self.currenciesListViewController.spinner.stopAnimating()
            self.currenciesListViewController.tableView.reloadData()
            
            let top = IndexPath(row: 0, section: 0)
            self.currenciesListViewController.tableView.scrollToRow(at: top, at: .bottom, animated: true)
        }
    }
    
    func showCurrencyDetails(selected: Int){
        let currencyDetailsViewController = CurrencyDetailsViewController()
        let currencyDetailsViewModel = CurrencyDetailsViewModel()
        currencyDetailsViewController.title = nbpData![0].rates[selected].currency
        currencyDetailsViewModel.code = nbpData![0].rates[selected].code
        currencyDetailsViewModel.table = self.selected
        currencyDetailsViewController.currencyDetailsViewModel = currencyDetailsViewModel
        currencyDetailsViewModel.currencyDetailsViewController = currencyDetailsViewController
        let navVC = UINavigationController(rootViewController: currencyDetailsViewController)
        currenciesListViewController.present(navVC, animated: true)
    }
}
