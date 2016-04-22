//
//  score.swift
//  japanize
//
//  Created by Alejandro Sanchez on 16/04/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Foundation
import MZFormSheetPresentationController

// TODO: Change the implementation into a singleton class.
func getScore() -> Int {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    if let score = userDefaults.valueForKey("score") {
        return score as! Int
    } else {
        return 0
    }
}

func incrementScore(increment: Int) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let score = getScore();
    let inc = score + increment
    userDefaults.setValue(inc, forKey: "score")
    userDefaults.synchronize()
}

func showScore(controller: UIViewController) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let navigationController = storyboard.instantiateViewControllerWithIdentifier("congratulationsViewController")
    let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
    formSheetController.presentationController?.contentViewSize = CGSizeMake(300, 300)
    formSheetController.presentationController?.shouldCenterVertically = true
    formSheetController.presentationController?.shouldCenterHorizontally = true
    
    controller.presentViewController(formSheetController, animated: true, completion: nil)
}
