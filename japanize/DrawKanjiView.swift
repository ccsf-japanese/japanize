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
            //use anchor to prevent unsatisfiable constraints
            v.translatesAutoresizingMaskIntoConstraints = false
            // TODO: replace with API calls that are compatible with iOS 8
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
        
        // mainImageView holds the “drawing so far,and tempImageView holds the line currently drawing
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        // get the current touch point and then draw a line with CGContextAddLineToPoint from lastPoint to currentPoint
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // brush size and opacity and brush stroke color
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        
        CGContextStrokePath(context)
        
        // wrap up the drawing context to render the new line into the temporary image view.
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // set swiped to true so you can keep track of whether there is a current swipe in progress
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // update the lastPoint
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
