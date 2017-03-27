import UIKit

class DetailTableViewCell: UITableViewCell {

  @IBOutlet weak var keyLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var valueButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.keyLabel.textColor = ThemeManager.currentTheme().mainColor
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    
    valueButton?.removeTarget(nil, action: nil, for: UIControlEvents.allTouchEvents)
  }

}
