//
//  DrawKanjiView.swift
//  FingerPrinting
//
//  Created by Xinxin Xie on 3/23/16.
//  Copyright © 2016 Xinxin Xie. All rights reserved.
//

import UIKit
protocol DrawKanjiViewDelegate: class {
    func drawKanjiView(view: DrawKanjiView, didCompleteStroke: Int)
    func drawKanjiViewDidComplete(view: DrawKanjiView)
}

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
    
    weak var dataSource: KanjiDrawingDataSource?
    weak var delegate: DrawKanjiViewDelegate?
    
    var touchedPoints = Set<String>()
    
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
            // TODO: replace with API calls that are compatible with iOS 8.(Done)
            
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: v, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: v, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: v, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: v, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
        }
    }

    
    func reset() {
        mainImageView.image = nil
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
    
    private func checkCurrentPoint(currentPoint: CGPoint) {
        if let dataSource = dataSource, kanji = dataSource.kanji, kanjiTransform = dataSource.kanjiTransform {
            let points = kanji.strokes[dataSource.nextStrokeIndex].points
            for (i, point) in points.enumerate() {
                let transformedPoint = CGPointApplyAffineTransform(point, kanjiTransform)
            
                //if the distance between current point and point on stroke is greater than 10, not update last point
                if checkDistance(currentPoint, sPoint: transformedPoint) {
                    if i+1 != points.count {
                        for j in i+1..<points.count {
                            if touchedPoints.contains(NSStringFromCGPoint(points[j])) {
                                return
                            }
                        }
                    }
                    touchedPoints.insert(NSStringFromCGPoint(point))
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            checkCurrentPoint(currentPoint)
            // update the lastPoint
            lastPoint = currentPoint
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // set swiped to true so you can keep track of whether there is a current swipe in progress
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            checkCurrentPoint(currentPoint)
            
            // update the lastPoint
            lastPoint = currentPoint
        }
 
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        if let dataSource = dataSource, kanji = dataSource.kanji {
            var complete = true
            for point in kanji.strokes[dataSource.nextStrokeIndex].points {
                if !touchedPoints.contains(NSStringFromCGPoint(point)) {
                    complete = false
                    break
                }
            }
            if complete {
                delegate?.drawKanjiView(self, didCompleteStroke: dataSource.nextStrokeIndex)
            }
        }
        
        touchedPoints.removeAll()
        tempImageView.image = nil
    }
    
    

    private func checkDistance(cPoint: CGPoint, sPoint: CGPoint) -> Bool {
        var isLess = false
        
        let distance = sqrt(pow((cPoint.x - sPoint.x), 2) + pow((cPoint.y - sPoint.y), 2))
        if distance < 20.0 {
            isLess = true
        }
        return isLess
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
