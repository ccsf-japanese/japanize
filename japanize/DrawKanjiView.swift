//
//  DrawKanjiView.swift
//  FingerPrinting
//
//  Created by Xinxin Xie on 3/23/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit

class DrawKanjiView: UIView {
    
    let tempImageView = UIImageView()
    let mainImageView = UIImageView()
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 100.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 8.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    private func setupConstraints() {
        for v in [tempImageView, mainImageView] {
            addSubview(v)
            //prevent unsatisfiable constraints
            v.translatesAutoresizingMaskIntoConstraints = false
            v.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
            v.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor).active = true
            v.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
            v.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        }
    }

    
    func reset() {
        mainImageView.image = nil
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self)
        }
    }
    
    
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContextWithOptions(mainImageView.frame.size, false, 0.0)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
