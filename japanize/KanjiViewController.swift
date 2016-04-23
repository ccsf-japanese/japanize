import UIKit

protocol KanjiDrawingDataSource: class {
  var nextStrokeIndex: Int { get }
  var character: Character? { get }
  var kanjiTransform: CGAffineTransform? { get }
  
}

protocol KanjiViewControllerDelegate: class {
  func kanjiViewController(kanjiViewController: KanjiViewController, didFinishDrawingKanji character: Character)
}

class KanjiViewController: UIViewController, KanjiDrawingDataSource, DrawKanjiViewDelegate {
  
  var level: Level?
  
  @IBOutlet weak var kanjiView: KanjiView!
  @IBOutlet weak var drawKanjiView: DrawKanjiView!
  
  weak var delegate: KanjiViewControllerDelegate?
  
  let undoButton = UIButton(type: .System)
  let clearButton = UIButton(type: .System)
  let meaningLabel = UILabel()
  
  var nextStrokeIndex = 0 {
    didSet {
      kanjiView.setNeedsDisplay()
    }
  }
  var character: Character? {
    didSet {
      nextStrokeIndex = 0
      meaningLabel.text = ""
      kanjiView.setNeedsDisplay()
    }
  }
  var kanjiTransform: CGAffineTransform? {
    didSet {
      kanjiView.setNeedsDisplay()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    view.addSubview(undoButton)
    view.addSubview(clearButton)
    view.addSubview(meaningLabel)
    
    //undoButton.setTitle("Undo", forState:.Normal)
    undoButton.setImage(UIImage.init(named: "undo"), forState: .Normal)
    //clearButton.setTitle("Clear", forState:.Normal)
    clearButton.setImage(UIImage.init(named: "cancel"), forState: .Normal)
    
    undoButton.titleLabel?.font = UIFont.systemFontOfSize(25)
    clearButton.titleLabel?.font = UIFont.systemFontOfSize(25)
    
    undoButton.translatesAutoresizingMaskIntoConstraints = false
    undoButton.addTarget(self, action: "undoButtonTapped", forControlEvents: .TouchUpInside)
    
    clearButton.translatesAutoresizingMaskIntoConstraints = false
    clearButton.addTarget(self, action: "clearButtonTapped", forControlEvents: .TouchUpInside)
    
    meaningLabel.translatesAutoresizingMaskIntoConstraints = false
    meaningLabel.textAlignment = .Center
    meaningLabel.numberOfLines = 2
    
    //undoButton constraints
    NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: undoButton, attribute: .Leading, multiplier: 1.0, constant: -15.0).active = true
    NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: undoButton, attribute: .Bottom, multiplier: 1.0, constant: 15.0).active = true
    
    //clearButton constraints
    NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: clearButton, attribute: .Trailing, multiplier: 1.0, constant: 15.0).active = true
    NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: clearButton, attribute: .Bottom, multiplier: 1.0, constant: 15.0).active = true
    
    //meaningLabel constraints
    NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: meaningLabel, attribute: .Trailing, multiplier: 1.0, constant: -15.0).active = true
    NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: meaningLabel, attribute: .Leading, multiplier: 1.0, constant: 15.0).active = true
    NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: meaningLabel, attribute: .Bottom, multiplier: 1.0, constant: 80.0).active = true
    
    self.drawKanjiView.delegate = self
    self.kanjiView.dataSource = self
    self.drawKanjiView.dataSource = self
    
    if let level = self.level {
      let chosenCharacter = level.characters[0]
      JapanizeFileClient.sharedInstance.dataForFilePath(chosenCharacter.svgURL,
                                                        completion: { (data, error) in
        if let svgData = data {
          chosenCharacter.setStrokesWithSVG(svgData)
          print("Level character ready!")
          self.character = chosenCharacter
        } else {
          assertionFailure("error downloading SVG")
        }
      })
    } else {
      setNewRandomCharacter()
    }
  }
  
  func undoButtonTapped() {
    if nextStrokeIndex > 0 {
      nextStrokeIndex -= 1
    }
  }
  func clearButtonTapped() {
    nextStrokeIndex = 0
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // TODO: copy to KanjiViewController and uncomment to set theme rgb(142, 68, 173)
  override func viewWillAppear(animated: Bool) {
    let themeColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1)
    let nav = self.navigationController?.navigationBar
    nav?.barTintColor = themeColor
    nav?.tintColor = UIColor.whiteColor()
    nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    tabBarController?.tabBar.tintColor = themeColor
  }
  
  override func viewDidLayoutSubviews() {
    let scale = min(kanjiView.frame.height, kanjiView.frame.width) / 109
    let transform = CGAffineTransformMakeScale(scale, scale)
    kanjiTransform = transform
  }
  
  func didCompleteStroke() {
    nextStrokeIndex += 1
    if let character = character {
      if let strokes = character.strokes {
        if nextStrokeIndex == strokes.count {
          if character.kind == "kanji" {
            meaningLabel.text = "\(character.meaning!)\n(Kanji)"
          } else if character.kind == "hiragana" {
            meaningLabel.text = "\(character.romaji!)\n(Hiragana)"
          } else if character.kind == "katakana" {
            meaningLabel.text = "\(character.romaji!)\n(Katakana)"
          } else {
            assertionFailure("unknown character kind")
          }
          let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 2))
          dispatch_after(delayTime, dispatch_get_main_queue()){
            self.setNewRandomCharacter()
          }
        }
      }
      delegate?.kanjiViewController(self, didFinishDrawingKanji: character)
    }
  }
  
  func setNewRandomCharacter() {
    // TODO: Consider refactoring nested code, adding error handling
    JapanizeClient.sharedInstance.book( { (book, error) -> () in
      if let book = book {
        var characters = Array<Character>()
        
        for chapter in book.chapters {
          for level in chapter.levels {
            for character in level.characters {
              characters.append(character)
            }
          }
        }
        
        let chosenCharacter = characters.sample()
        JapanizeFileClient.sharedInstance.dataForFilePath(chosenCharacter.svgURL,
          completion: { (data, error) in
            if let svgData = data {
              chosenCharacter.setStrokesWithSVG(svgData)
              print("Random character ready!")
              self.character = chosenCharacter
            } else {
              assertionFailure("error downloading SVG")
            }
        })
      }
    })
  }
  
}
