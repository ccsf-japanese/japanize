import UIKit
import ChameleonFramework

class ChapterCell: UITableViewCell {
  
  var chapter: Chapter?
  var viewController: UIViewController?
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

extension ChapterCell: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let levelCell = collectionView.cellForItemAtIndexPath(indexPath) as! LevelCell
    if !levelCell.disabled {
      viewController?.performSegueWithIdentifier("ProgressToDrawingSegue", sender: levelCell)
    }
  }
}

extension ChapterCell : UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let chapter = chapter {
      return chapter.levels.count
    } else {
      return 0
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LevelCell", forIndexPath: indexPath) as! LevelCell
    
    let currentLevel = chapter!.levels[indexPath.row]
    let previousLevel = indexPath.row > 0 ? chapter?.levels[indexPath.row - 1] : nil
    
    if User.currentUser?.levelsComplete[currentLevel.id] != nil {
      cell.disabled = false
      // cell text colour UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
      // cell background UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
      cell.backgroundColor = FlatYellowDark()
      cell.levelLabel.textColor = FlatYellow()
      cell.goal1Label.textColor = FlatYellow()
      cell.goal2Label.textColor = FlatYellow()
      cell.goal3Label.textColor = FlatYellow()
      cell.starButton.tintColor = FlatYellow()
      cell.lockButton.hidden = true
    } else if indexPath.row == 0 || previousLevel != nil && User.currentUser?.levelsComplete[previousLevel!.id] != nil {
      cell.disabled = false
      // Levels that have been started, but not completed
      cell.backgroundColor = FlatMintDark()
      cell.levelLabel.textColor = FlatWhite() // UIColor.whiteColor()
      cell.goal1Label.textColor = FlatWhite()
      cell.goal2Label.textColor = FlatWhite()
      cell.goal3Label.textColor = FlatWhite()
      cell.starButton.hidden = true
      cell.lockButton.hidden = true
    } else {
      cell.disabled = true
      // cell text colour UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
      // cell background UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
      cell.backgroundColor = FlatTealDark()
      cell.levelLabel.textColor = FlatTeal()
      cell.goal1Label.textColor = FlatTeal()
      cell.goal2Label.textColor = FlatTeal()
      cell.goal3Label.textColor = FlatTeal()
      cell.starButton.hidden = true
      cell.lockButton.hidden = false
      cell.lockButton.tintColor = FlatTeal()
    }
    
    cell.level = currentLevel
    cell.levelLabel.text = cell.level!.name!
    cell.layer.cornerRadius = 4.0

    if let character = cell.level?.characters[0] {
      cell.goal1Label.text = character.value
      if character.kind == "kanji" {
        cell.goal2Label.text = "\(character.meaning!)"
      } else {
        cell.goal2Label.text = "\(character.kind.capitalizedString) '\(character.romaji!)'"
      }
    } else {
      assertionFailure("character should be defined")
    }
    
    cell.goal3Label.text = ""
    if let words = cell.level?.words {
      if words.count > 0 {
        cell.goal3Label.text = "Speak \(words.count) words"
      }
    }
   
    return cell
  }
  
}
