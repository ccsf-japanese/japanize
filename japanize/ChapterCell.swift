import UIKit

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
      //set cell text colour green
      //cell.completedImage.hidden = false //rgb(230, 126, 34)rgb(243, 156, 18)
      cell.backgroundColor = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
      cell.levelLabel.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
      cell.goal1Label.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
      cell.goal2Label.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
      cell.goal3Label.textColor = UIColor(red: 234/255, green: 156/255, blue: 18/255, alpha: 1)
    } else if indexPath.row == 0 || previousLevel != nil && User.currentUser?.levelsComplete[previousLevel!.id] != nil {
      cell.disabled = false
      //levelComplete == false {
      // Levels that have been started, but not completed
      cell.backgroundColor = UIColor.flatMintColorDark()
      cell.levelLabel.textColor = UIColor.whiteColor()
      cell.goal1Label.textColor = UIColor.whiteColor()
      cell.goal2Label.textColor = UIColor.whiteColor()
      cell.goal3Label.textColor = UIColor.whiteColor()
    } else {
      // does level not touched fire this (as nil)
      //set cell inactive and grey
      // cell.lockedImage.hidden = false rgb(52, 73, 94)rgb(44, 62, 80)
      cell.backgroundColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
      cell.levelLabel.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
      cell.goal1Label.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
      cell.goal2Label.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
      cell.goal3Label.textColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
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
