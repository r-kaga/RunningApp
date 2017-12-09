import UIKit

class HomeCustomCell : UICollectionViewCell{
    
    var textLabel: UILabel?
    var imageView: UIImageView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let defaultImage: UIImage = UIImage(named:"asphalt-highway")!
        
        imageView = UIImageView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
        imageView?.image = defaultImage
        
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 2))
        textLabel?.text = "nil"
        textLabel?.textAlignment = .center
        textLabel?.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        textLabel?.textColor = UIColor.white
        
        self.contentView.addSubview(imageView!)
        self.contentView.addSubview(textLabel!)
        
    }
    
}
