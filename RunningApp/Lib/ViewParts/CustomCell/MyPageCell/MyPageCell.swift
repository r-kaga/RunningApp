

import Foundation
import UIKit
import RealmSwift


class MyPageCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.masksToBounds = true
        
        cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
//        cardView.layer.borderWidth = 1.0
//        cardView.layer.borderColor = UIColor.gray.cgColor
        cardView.layer.shadowColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        
    }
    
}
