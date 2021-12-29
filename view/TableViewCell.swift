//
//  TableViewCell.swift
//  FirebaseDemo
//
//  Created by Asmita Borawake on 24/12/21.
//

import UIKit
import Kingfisher
class TableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    
    
    var chatModel : ChatModle?{
        didSet{
            nameLbl.text = chatModel?.name
            textLbl.text = chatModel?.text
            
            let url  = URL(string: (chatModel?.profileImgUrl)!)
            
            if let url = url {
                imgView.kf.setImage(with: url)
                imgView.kf.indicatorType = .activity
            }
           

        }
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
