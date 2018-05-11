

import Foundation
import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var settingValueLabel: UILabel!

    override func awakeFromNib() {
        settingValueLabel.text = ""
    }

}



