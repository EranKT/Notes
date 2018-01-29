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
    
  //  let imgUser = UIImageView()
  //  let labUerName = UILabel()
  //  let labMessage = UILabel()
  //  let labTime = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
     //   imgUser.backgroundColor = UIColor.blue
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
      //  imgUser.translatesAutoresizingMaskIntoConstraints = false
      //  labUerName.translatesAutoresizingMaskIntoConstraints = false
      //  labMessage.translatesAutoresizingMaskIntoConstraints = false
     //   labTime.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(priceLabel)
      //  contentView.addSubview(imgUser)
      //  contentView.addSubview(labUerName)
     //   contentView.addSubview(labMessage)
     //   contentView.addSubview(labTime)
        
        priceLabel.text = "";

        let viewsDict = [
            "price" : priceLabel,
           // "image" : imgUser,
          //  "username" : labUerName,
          //  "message" : labMessage,
          //  "labTime" : labTime,
            ] as [String : Any]
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[price]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[price]-|", options: [], metrics: nil, views: viewsDict))
        //   contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image(100)]", options: [], metrics: nil, views: viewsDict))
     //   contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[labTime]-|", options: [], metrics: nil, views: viewsDict))
    //    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[username]-[message]-|", options: [], metrics: nil, views: viewsDict))
    //    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[username]-[image(10)]-|", options: [], metrics: nil, views: viewsDict))
   //     contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[message]-[labTime]-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priceLabel.text = "Some text";
        priceLabel.frame = CGRect.init(
            x: self.frame.width/2,
            y: self.frame.height/2,
            width: self.frame.width/4,
            height: self.frame.height/4)
        self.addSubview(priceLabel)
   //     self.textLabel?.text = "asadasdasa"// _currentViewList[indexPath.row]

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
*/
}
