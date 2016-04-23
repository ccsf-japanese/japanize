import UIKit

class Stroke {
  
  let points: [CGPoint]
  
  // Internal path
  private let _path = UIBezierPath()
  
  var path: UIBezierPath {
    get {
      // Defensive copy
      return _path.copy() as! UIBezierPath
    }
  }
  
  init(pathString: String) {
    var tokens = [String]()
    var token = ""
    let letters = NSCharacterSet.letterCharacterSet()
    let digits = NSCharacterSet.decimalDigitCharacterSet()
    var points = [CGPoint]()
    
    for uni in pathString.unicodeScalars {
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
        } else {
          token.append(uni)
        }
      }
    }
    if !token.isEmpty {
      tokens.append(token)
    }
    
    tokens = tokens.reverse()
    
    var previousControlPoint: CGPoint?
    while !tokens.isEmpty {
      let last = tokens.removeLast()
      if last == "M" {
        let x = tokens.removeLast()
        let y = tokens.removeLast()
        let point = CGPoint(x: Double(x)!, y: Double(y)!)
        points.append(point)
        _path.moveToPoint(point)
        previousControlPoint = nil
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
        
        let point: CGPoint
        if last == "c" {
          point = CGPoint(x: _path.currentPoint.x + endPoint.x, y: _path.currentPoint.y + endPoint.y)
          points.append(point)
          previousControlPoint = CGPoint(x: _path.currentPoint.x + c2Point.x, y: _path.currentPoint.y + c2Point.y)
          _path.addCurveToRelativePoint(endPoint, controlPoint1: c1Point, controlPoint2: c2Point)
        } else {
          point = endPoint
          points.append(point)
          previousControlPoint = c2Point
          _path.addCurveToPoint(endPoint, controlPoint1: c1Point, controlPoint2: c2Point)
        }
      } else if last == "s" || last == "S" {
        let c2x = tokens.removeLast()
        let c2y = tokens.removeLast()
        let ex = tokens.removeLast()
        let ey = tokens.removeLast()
        
        let c2Point = CGPoint(x: Double(c2x)!, y: Double(c2y)!)
        let endPoint = CGPoint(x: Double(ex)!, y: Double(ey)!)
        let c1Point: CGPoint
        if let previousControlPoint = previousControlPoint {
          c1Point = reflection(_path.currentPoint, controlPoint: previousControlPoint)
        } else {
          c1Point = _path.currentPoint
        }
        let point: CGPoint
        
        let absC2Point: CGPoint
        let absEndPoint: CGPoint
        if last == "s" {
          absC2Point = CGPoint(x: _path.currentPoint.x + c2Point.x, y: _path.currentPoint.y + c2Point.y)
          absEndPoint = CGPoint(x: _path.currentPoint.x + endPoint.x, y: _path.currentPoint.y + endPoint.y)
        } else {
          absC2Point = c2Point
          absEndPoint = endPoint
        }
        
        point = absEndPoint
        points.append(point)
        previousControlPoint = absC2Point
        _path.addCurveToPoint(absEndPoint, controlPoint1: c1Point, controlPoint2: absC2Point)
      }
    }
    
    self.points = points
  }
  
}

private func reflection(point: CGPoint, controlPoint: CGPoint) -> CGPoint {
  return CGPoint(x: point.x * 2 - controlPoint.x, y: point.y * 2 - controlPoint.y)
}
