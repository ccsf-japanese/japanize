import UIKit

class KanjiView: UIView {
  
  weak var dataSource: KanjiDrawingDataSource?
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    contentMode = .Redraw
    
    guard let dataSource = dataSource,
      let strokes = dataSource.character?.strokes,
      let kanjiTransform = dataSource.kanjiTransform else {
        return
    }
    let nextStrokeIndex = dataSource.nextStrokeIndex
    
    for (i, stroke) in strokes.enumerate().reverse() {
      let color = i >= nextStrokeIndex ? UIColor.lightGrayColor() : UIColor.blackColor()
      color.setStroke()
      let path = stroke.path
      path.applyTransform(kanjiTransform)
      path.lineWidth = 15.0
      path.lineCapStyle = .Round
      path.lineJoinStyle = .Round
      path.stroke()
    }
    
    if nextStrokeIndex < strokes.count {
      let stroke = strokes[nextStrokeIndex]
      if let point = stroke.points.first {
        drawCircleAtPoint(point, color: UIColor.greenColor(), transform: kanjiTransform)
      }
      if let point = stroke.points.last {
        drawCircleAtPoint(point, color: UIColor.redColor(), transform: kanjiTransform)
      }
    }
  }
  
  func drawCircleAtPoint(point: CGPoint, color: UIColor, transform: CGAffineTransform) {
    let radius: CGFloat = 5.0
    let origin = CGPoint(x: point.x - radius / 2.0, y: point.y - radius / 2.0)
    let outline = CGRect(origin: origin, size: CGSize(width: radius, height: radius))
    let circlePath = UIBezierPath(ovalInRect: outline)
    circlePath.applyTransform(transform)
    color.setFill()
    circlePath.fill()
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
