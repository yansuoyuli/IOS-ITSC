

import UIKit

class SafetyTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        title.borderStyle = .none
        title.isEnabled = false
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
