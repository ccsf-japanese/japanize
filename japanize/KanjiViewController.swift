//
//  ViewController.swift
//  drawKanji
//
//  Created by Xinxin Xie on 3/16/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class KanjiViewController: UIViewController {
    
    @IBOutlet weak var kanjiView: KanjiView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor(red: 18/255, green: 165/255, blue: 244/255, alpha: 0)
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
        var strokes: [String] = []
        let path = NSBundle.mainBundle().pathForResource("054a8", ofType: "svg")!
        let content: NSString = try! String(contentsOfFile: path)
        let regex = try! NSRegularExpression(pattern: " d=\"(.*)\"", options: [])
        
        let matches = regex.matchesInString(content as String, options: [], range: NSRange(location: 0, length: content.length))
        for match in matches {
            let range = match.rangeAtIndex(1)
            strokes.append(content.substringWithRange(range))
        }
        kanjiView.strokes = strokes
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

