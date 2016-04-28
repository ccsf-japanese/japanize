import UIKit

class LevelCell: UICollectionViewCell {
  
  var level: Level?
  var disabled: Bool = true
  
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var goal1Label: UILabel!
  @IBOutlet weak var goal2Label: UILabel!
  @IBOutlet weak var goal3Label: UILabel!
  @IBOutlet weak var starButton: UIButton!
  @IBOutlet weak var lockButton: UIButton!
}
