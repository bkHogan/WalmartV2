//
//  CountryTableViewCell.swift
//  WalmartCodingTest
//
//  Created by Brian Hogan on 3/28/24.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    func configure(with country: Country) {
        nameLabel.text = "\(country.name), \(country.region)"
        codeLabel.text = country.code
        capitalLabel.text = country.capital

        // Log the values assigned to UI elements
            print("Name Label Text:", nameLabel.text ?? "Empty")
            print("Code Label Text:", codeLabel.text ?? "Empty")
            print("Capital Label Text:", capitalLabel.text ?? "Empty")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

