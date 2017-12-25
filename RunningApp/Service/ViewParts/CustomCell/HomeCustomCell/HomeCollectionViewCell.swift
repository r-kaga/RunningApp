

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var carorieLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 7.5
        cardView.clipsToBounds = true
    }

}
