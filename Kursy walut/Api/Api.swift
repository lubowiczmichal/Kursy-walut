//
//  Api.swift
//  Kursy walut
//
//  Created by Michał Lubowicz on 01/07/2021.
//

import Foundation

class Api {
    
    static func request(url: String) -> Data{
        var dataToReturn = Data()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .background).async {
            
            let request = URLRequest(url: URL(string: url)!)
            let task = URLSession.shared.dataTask(with: request) { (data,request,error) in
                guard let data = data else{
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    return
                }
                dataToReturn = data
                group.leave()
            }
            task.resume()
        }
        group.wait()
        return dataToReturn
    }
    
}
