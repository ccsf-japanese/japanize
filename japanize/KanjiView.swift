//
//  KanjiView.swift
//  drawKanji
//
//  Created by Xinxin Xie on 3/16/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class KanjiView: UIView {
    
    var strokes: [String] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        contentMode = .Redraw
        
        let path = UIBezierPath()
        UIColor.blackColor().setStroke()
        for stroke in strokes {
            drawString(stroke, path: path)
        }
        let scale = min(rect.height, rect.width) / 109
        path.applyTransform(CGAffineTransformMakeScale(scale, scale))
        path.lineWidth = 5.0
        
        path.stroke()
        
    }
    
    private func drawString(string: String, path: UIBezierPath) {
        var tokens = [String]()
        var token = ""
        let letters = NSCharacterSet.letterCharacterSet()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        
        for uni in string.unicodeScalars {
            if letters.longCharacterIsMember(uni.value) {
                if !token.isEmpty {
                    tokens.append(token)
                    token = ""
                }
                tokens.append(String(uni))
            } else if digits.longCharacterIsMember(uni.value) || String(uni) == "." {
                token.append(uni)
            } else if String(uni) == "," {
                if !token.isEmpty {
                    tokens.append(token)
                    token = ""
                }
            } else if String(uni) == "-" {
                if !token.isEmpty {
                    tokens.append(token)
                    token = "-"
                }
            }
        }
        if !token.isEmpty {
            tokens.append(token)
        }
        
        tokens = tokens.reverse()
        
        while !tokens.isEmpty {
            let last = tokens.removeLast()
            if last == "M" {
                let x = tokens.removeLast()
                let y = tokens.removeLast()
                let point = CGPoint(x: Double(x)!, y: Double(y)!)
                path.moveToPoint(point)
            } else if last == "c" || last == "C" {
                let c1x = tokens.removeLast()
                let c1y = tokens.removeLast()
                let c2x = tokens.removeLast()
                let c2y = tokens.removeLast()
                let ex = tokens.removeLast()
                let ey = tokens.removeLast()
                
                let c1Point = CGPoint(x: Double(c1x)!, y: Double(c1y)!)
                let c2Point = CGPoint(x: Double(c2x)!, y: Double(c2y)!)
                let endPoint = CGPoint(x: Double(ex)!, y: Double(ey)!)
                
                if last == "c" {
                    path.addCurveToRelativePoint(endPoint, controlPoint1: c1Point, controlPoint2: c2Point)
                } else {
                    path.addCurveToPoint(endPoint, controlPoint1: c1Point, controlPoint2: c2Point)
                }
            }
        }
    }
}

extension UIBezierPath {
    func addCurveToRelativePoint(endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.addCurveToPoint(
            CGPoint(x: currentPoint.x + endPoint.x, y: currentPoint.y +  endPoint.y),
            controlPoint1: CGPoint(x: currentPoint.x + controlPoint1.x, y: currentPoint.y + controlPoint1.y),
            controlPoint2: CGPoint(x: currentPoint.x + controlPoint2.x, y: currentPoint.y + controlPoint2.y))
    }
}
