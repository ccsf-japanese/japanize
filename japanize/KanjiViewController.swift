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
    var kanji: Kanji? { get }
    var kanjiTransform: CGAffineTransform? { get }
}

class KanjiViewController: UIViewController, KanjiDrawingDataSource, DrawKanjiViewDelegate {
    
    @IBOutlet weak var kanjiView: KanjiView!
    @IBOutlet weak var drawKanjiView: DrawKanjiView!
    
    let undoButton = UIButton(type: .System)
    let clearButton = UIButton(type: .System)
    
    var nextStrokeIndex = 0 {
        didSet {
            kanjiView.setNeedsDisplay()
        }
    }
    var kanji: Kanji? {
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
        undoButton.setTitle("Undo", forState:.Normal)
        clearButton.setTitle("Clear", forState:.Normal)
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
        
      
        kanji = Kanji()
        kanjiView.dataSource = self
        drawKanjiView.dataSource = self
        drawKanjiView.delegate = self
        
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
        if let kanji = kanji {
            nextStrokeIndex %= kanji.strokes.count
        }
    }
}

