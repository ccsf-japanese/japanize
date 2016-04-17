//
//  ViewController.swift
//  drawKanji
//
//  Created by Xinxin Xie on 3/16/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

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
    
    @IBOutlet weak var kanjiView: KanjiView!
    @IBOutlet weak var drawKanjiView: DrawKanjiView!
    
    weak var delegate: KanjiViewControllerDelegate?
    
    let undoButton = UIButton(type: .System)
    let clearButton = UIButton(type: .System)
    
    var nextStrokeIndex = 0 {
        didSet {
            kanjiView.setNeedsDisplay()
        }
    }
    var character: Character? {
        didSet {
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
        
        NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: undoButton, attribute: .Leading, multiplier: 1.0, constant: -15.0).active = true
        NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: undoButton, attribute: .Bottom, multiplier: 1.0, constant: 15.0).active = true
        
        NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: clearButton, attribute: .Trailing, multiplier: 1.0, constant: 15.0).active = true
        NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: clearButton, attribute: .Bottom, multiplier: 1.0, constant: 15.0).active = true
      
      self.drawKanjiView.delegate = self
      self.kanjiView.dataSource = self
      self.drawKanjiView.dataSource = self
      setNewRandomCharacter()
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
//    TODO: copy to KanjiViewController and uncomment to set theme rgb(142, 68, 173)
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
    
    func drawKanjiView(view: DrawKanjiView, didCompleteStroke: Int) {
        nextStrokeIndex += 1
        // TODO: Change Kanji when out of strokes
        if let strokes = character!.strokes {
          if nextStrokeIndex == strokes.count {
            setNewRandomCharacter()
            nextStrokeIndex = 0
          }
        }
    }
    
    func drawKanjiViewDidComplete(view: DrawKanjiView) {
        if let character = character {
            delegate?.kanjiViewController(self, didFinishDrawingKanji: character)
        }
      
    }
  
  func setNewRandomCharacter() {
    // TODO: Consider refactoring nested code, adding error handling
    JapanizeClient.sharedInstance.book( { (book, error) -> () in
      if let book = book {
        var characters = Array<String>()
        
        for chapter in book.chapters {
          for level in chapter.levels {
            for character in level.characters {
              characters.append(character)
            }
          }
        }
        
        let chosenCharacter = characters.sample()
        JapanizeClient.sharedInstance.characterWithID(chosenCharacter, completion: { (character, error) in
          if let character = character {
            if let svgURL = character.svgURL {
              JapanizeFileClient.sharedInstance.dataForFilePath(svgURL, completion: { (data, error) in
                if let svgData = data {
                  character.setStrokesWithSVG(svgData)
                  print("Random character ready!")
                  self.character = character
                }
              })
            }
          }
        })
      }
    })
  }
  
}
