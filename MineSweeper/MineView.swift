// View for mine tiles

import UIKit

class MineView: UIView {
    
    private struct Offsets {
        static let radiusFactor = 0.25
        static let lineGapFactor = 0.10
        static let diagonalTopLeftBottomRightGapFactor = 0.2
        static let diagonalBottomLeftTopRightGapFactor = diagonalTopLeftBottomRightGapFactor
        static let heightFactor = 0.10
        static let diagonalLineWidth = 0.10
    }
    
    override func draw(_ rect: CGRect) {
        let width = Double(bounds.size.width)
        let height = Double(bounds.size.height)
        
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let radius = Offsets.radiusFactor * Double(width)
        //print(width, radius)
        let centerCircle = UIBezierPath(arcCenter: centerPoint, radius: CGFloat(radius), startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: false)
        
        let horizontalRect = CGRect(x: width * Offsets.lineGapFactor,
                                    y: Double(bounds.midY) - width * Offsets.lineGapFactor / 2.0,
                                    width: width - 2.0 * width * Offsets.lineGapFactor,
                                    height: height * Offsets.heightFactor)
        let vertialRec = CGRect(x: Double(bounds.midX) - width * Offsets.lineGapFactor / 2.0,
                                y: height * Offsets.lineGapFactor,
                                width: height * Offsets.lineGapFactor,
                                height: height - width * 2.0 * Offsets.lineGapFactor)
        
        let horizontalLine = UIBezierPath(rect: horizontalRect)
        let verticalLine = UIBezierPath(rect: vertialRec)
        let diagonalTopBottom = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        diagonalTopBottom.move(to: CGPoint(x: width * Offsets.diagonalBottomLeftTopRightGapFactor,
                                           y: height * Offsets.diagonalBottomLeftTopRightGapFactor))
        diagonalTopBottom.addLine(to: CGPoint(x: width - width * Offsets.diagonalBottomLeftTopRightGapFactor,
                                              y: height - height * Offsets.diagonalBottomLeftTopRightGapFactor))
        diagonalTopBottom.lineWidth = CGFloat(width * Offsets.diagonalLineWidth)
        
        let diagonalBottomTop = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0, height: 0))
        diagonalBottomTop.move(to: CGPoint(x: width - width * Offsets.diagonalBottomLeftTopRightGapFactor,
                                           y: height * Offsets.diagonalBottomLeftTopRightGapFactor))
        diagonalBottomTop.addLine(to: CGPoint(x: width * Offsets.diagonalBottomLeftTopRightGapFactor,
                                              y: height - height * Offsets.diagonalBottomLeftTopRightGapFactor))
        diagonalBottomTop.lineWidth = diagonalTopBottom.lineWidth
        
        UIColor.red.setFill()
        horizontalLine.fill()
        verticalLine.fill()
        diagonalTopBottom.fill()
        diagonalBottomTop.fill()

        UIColor.red.setStroke()
        centerCircle.stroke()
        diagonalTopBottom.stroke()
        diagonalBottomTop.stroke()
        
        UIColor.black.setFill()
        centerCircle.fill()
    }

}
