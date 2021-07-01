//
//  CurrencyDetailsViewModel.swift
//  Kursy walut
//
//  Created by Michał Lubowicz on 30/06/2021.
//

import Foundation

class CurrencyDetailsViewModel{
    var nbpData: NBPDataElement?
    var code: String?
    var table: String?
    var startDate: Date = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
    var endDate: Date = Date()
    
    var currencyDetailsViewController: CurrencyDetailsViewController?

    
    
    func spinnerAndLoad(){
        currencyDetailsViewController?.spinner.startAnimating()
        DispatchQueue.main.async {
            self.load()
        }
    }
    
    func load() {
        let dataToParse = Api.request(url: "https://api.nbp.pl/api/exchangerates/rates/" + self.table! + "/" + self.code! + "/" + self.formatDate(date: self.startDate) + "/" + self.formatDate(date: self.endDate) + "/")
        self.parse(json: dataToParse)
    }
    
    
    
    func parse(json: Data) {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .background).async {
            let decoder = JSONDecoder()
            do {
                self.nbpData = try decoder.decode(NBPDataElement.self, from: json)
            } catch {
                print(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
        DispatchQueue.main.async { self.currencyDetailsViewController?.spinner.stopAnimating()
            self.currencyDetailsViewController?.tableView.reloadData()
            
            let top = IndexPath(row: 0, section: 0)
            self.currencyDetailsViewController?.tableView.scrollToRow(at: top, at: .bottom, animated: true)
        }
        
        var sum: Double = 0.0
        for rate in nbpData!.rates{
            sum += rate.mid ?? (rate.ask! + rate.bid!)/2
        }
        
        let average: Double = sum/Double(nbpData!.rates.count)
        
        currencyDetailsViewController?.textLabel.text = "Średnia cena waluty " + (nbpData?.currency)! + " w dniach " + formatDate(date: startDate) + " - " + formatDate(date: endDate) + " to " + String(format: "%.4f", average) + " PLN"
    }
    
    func formatDate(date: Date) -> String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
