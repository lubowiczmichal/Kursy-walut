//
//  CustomTableViewCell.swift
//  Kursy walut
//
//  Created by Michał Lubowicz on 30/06/2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"
    
    private let flagLabel = UILabel()
    private let codeLabel = UILabel()
    private let rateLabel = UILabel()
    private let fullNameLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(flagLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(dateLabel)
    }
    
    public func config(code: String, fullName: String ,rate: Float, date: String){
        flagLabel.text = flag(currencyCode: code)
        codeLabel.text = code
        rateLabel.text = String(format: "Kurs: %.4f", rate)
        fullNameLabel.text = fullName
        dateLabel.text = date
    }
    
    private func flag(currencyCode:String) -> String {
        var countryCode = String(currencyCode.prefix(2))
        switch countryCode {
            case "XO":
                countryCode = "CI"
            case "XA":
                countryCode = "CM"
            case "XC":
                countryCode = "AT"
            case "XP":
                countryCode = "PF"
            case "AN":
                countryCode = "CW"
            case "XD":
                return ""
            default:
                break
        }
        let base : UInt32 = 127397
        var flag = ""
        for v in countryCode.unicodeScalars {
            flag.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(flag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flagLabel.frame = CGRect(x: 5, y: 5, width: 100, height: 20)
        codeLabel.frame = CGRect(x:UIScreen.main.bounds.width/3, y: 5, width: 100, height: 20)
        rateLabel.frame = CGRect(x: 2*UIScreen.main.bounds.width/3, y: 5, width: 150, height: 20)
        fullNameLabel.frame = CGRect(x: 5, y: 30, width: UIScreen.main.bounds.width - 110, height: 30)
        dateLabel.frame = CGRect(x: UIScreen.main.bounds.width - 105, y: 30, width: 100, height: 30)
    }
    
}
