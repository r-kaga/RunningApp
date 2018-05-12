

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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 10.0
        clipsToBounds = true

        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.3

//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOpacity = 0.5 // 透明度
//        layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
//        layer.shadowRadius = 5 // ぼかし量

    }
    
    func setRunData(_ runData: RealmDataSet) {
        dateLabel.text = runData.date
        distanceLabel.text = runData.distance
        timeLabel.text = runData.time
    }

}
