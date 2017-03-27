import UIKit

class ScheduleTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    nameLabel.textColor = ThemeManager.currentTheme().mainColor
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
