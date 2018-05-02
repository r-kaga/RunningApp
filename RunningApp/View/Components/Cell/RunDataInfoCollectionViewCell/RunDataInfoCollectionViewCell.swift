

import UIKit

class RunDataInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.numberOfLines = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
