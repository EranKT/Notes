//
//  SecondTableCell.swift
//  NewNotes
//
//  Created by EKT DIGIDESIGN on 1/23/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//

import UIKit

class SecondTableCell: UITableViewCell {

    var priceLabel = UILabel()
    
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(priceLabel)
       priceLabel.text = "";

        let viewsDict = [
            "price" : priceLabel,
            ] as [String : Any]
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[price]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[price]-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
