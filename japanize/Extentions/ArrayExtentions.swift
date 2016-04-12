//
//  ArrayExtentions.swift
//  japanize
//
//  Created by Dylan Smith on 4/11/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

extension Array {
    func sample() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}