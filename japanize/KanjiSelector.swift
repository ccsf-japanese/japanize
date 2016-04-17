//
//  KanjiSelector.swift
//  japanize
//
//  Created by Xinxin Xie on 4/16/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import Foundation

class KanjiSelector {
    
    let filteredItems: [String]
    
    init() {
        let fileManager = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        if let items = try? fileManager.contentsOfDirectoryAtPath(path) {
            filteredItems = items.filter({ item in
                (item as NSString).pathExtension == "svg"
            }).map({ item in
                (item as NSString).stringByReplacingOccurrencesOfString(".svg", withString: "")
            })
        } else {
            filteredItems = []
        }
    }
    
    func randomKanji() -> Kanji? {
        if filteredItems.isEmpty {
            return nil
        } else {
            let fileName = filteredItems.sample()
            return Kanji(fileName: fileName)
        }
    }
    

}

