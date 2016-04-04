//
//  Kanji.swift
//  japanize
//
//  Created by Xinxin Xie on 4/3/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class Kanji {
    
    let strokes: [Stroke]
    
    init(pathStrings: [String]) {
        var strokes: [Stroke] = []
        for pathString in pathStrings {
            strokes.append(Stroke(pathString: pathString))
        }
        self.strokes = strokes
    }
    
    
    
}