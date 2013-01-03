//
//  ClustersGrapher.swift
//  Clusters
//
//  Created by Sriharsha Sammeta on 15/03/15.
//  Copyright (c) 2015 Sriharsha Sammeta. All rights reserved.
//

import UIKit

class ClusterGrapher{
    var rect: CGRect
    let backGroundColor: UIColor
    let foreGroundColor: UIColor
    let offSet: CGFloat
    let startingValueX:CGFloat
    let endingValueX: CGFloat
    let startingValueY: CGFloat
    let endingValueY: CGFloat
    var scaleX:CGFloat = 1
    var scaleY:CGFloat = 1
    var incrementorX: CGFloat = 1
    var incrementorY: CGFloat = 1
    var startPointXX:CGFloat = 0
    var startPointXY:CGFloat = 0
    var startPointYX:CGFloat = 0
    var startPointYY:CGFloat = 0
    struct constants{
        static let localOffset:CGFloat = 5
    }
    init(rect:CGRect,backGroundColor:UIColor,foreGroundColor:UIColor,offSet:CGFloat,startingValueX:CGFloat,endingValueX:CGFloat,startingValueY:CGFloat,endingValueY:CGFloat) {
        self.rect = rect
        self.backGroundColor = backGroundColor
        self.foreGroundColor = foreGroundColor
        self.offSet = offSet
        self.startingValueX = startingValueX
        self.endingValueX = endingValueX
        self.startingValueY = startingValueY
        self.endingValueY = endingValueY
    }

    func drawVerticalAxes(){
        let path = UIBezierPath()
        var xValue = self.rect.minX + offSet
        var yValue = self.rect.minY
        path.moveToPoint(CGPoint(x:xValue,y:yValue))
        for ;yValue < self.rect.maxY ; yValue++ {
            path.addLineToPoint(CGPoint(x:xValue,y: yValue))
        }
        foreGroundColor.setStroke()
        path.stroke()
    }
    func drawHorizontalAxes(){
        let path = UIBezierPath()
        var xValue = self.rect.minX
        var yValue = self.rect.maxY - offSet
        path.moveToPoint(CGPoint(x:xValue , y:yValue))
        for  ; xValue < self.rect.maxX ; xValue++ {
            path.addLineToPoint(CGPoint(x: xValue,y: yValue))
        }
        foreGroundColor.setStroke()
        path.stroke()

    }
    
    func drawUnitsOnAxes(){
        var text = "99.99"
        let path = UIBezierPath()
        let attributes = [
            NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote),
            NSForegroundColorAttributeName : self.foreGroundColor
        ]

        
        func determineScaleAndIncrementorForHorziontal(){
            var count = (endingValueX - (startingValueX + 1))
            text = "99.99"
            incrementorX = 1
            while((self.rect.width - offSet - constants.localOffset - text.sizeWithAttributes(attributes).width * count) < 0){
                    incrementorX++
                    count = (endingValueX - (startingValueX + 1)) / incrementorX
                    println("countX:\(count)")
            }
//            incrementorX++
//            count = (endingValueX - (startingValueX + 1)) / incrementorX
//            incrementorX++
//            count = (endingValueX - (startingValueX + 1)) / incrementorX
//            println("\(count)")
            scaleX = (self.rect.width - offSet - constants.localOffset) / (count + 1)
        }
        func determineScaleAndIncrementorForVertical(){
            var count = (endingValueY - (startingValueY + 1))
            text = "99.99"
            while((self.rect.height - offSet - constants.localOffset - constants.localOffset - text.sizeWithAttributes(attributes).height * count)  < 0){
                incrementorY++
                count = (endingValueY - (startingValueY + 1)) / incrementorY
                println("countY: \(count)")
            }
//            incrementorY++
//            count = (endingValueY - (startingValueY + 1)) / incrementorY
//            println("\(count)")
//            incrementorY++
//            count = (endingValueY - (startingValueY + 1)) / incrementorY
            scaleY = (self.rect.height - offSet - constants.localOffset - constants.localOffset) / (count + 1)
        }
        func drawUnitsHorizontally(){
            var xValue = self.rect.minX + offSet + constants.localOffset
            var yValue = self.rect.maxY - offSet + constants.localOffset
            startPointXX = xValue
            startPointXY = yValue
            path.moveToPoint(CGPoint(x:xValue,y:yValue))
            var textRect:CGRect?
            var x = self.startingValueX
            for ;  x <= endingValueX ; xValue += scaleX, x += incrementorX {
                text = "\(x)"
                println("drew \(x)")
                println("points: \(xValue)")
                textRect = CGRect(origin: CGPoint(x:xValue,y:yValue), size: text.sizeWithAttributes(attributes))
                text.drawInRect(textRect! , withAttributes:attributes)
            }
        }
        func drawUnitsVertically(){
            var xValue = self.rect.minX + constants.localOffset
            var yValue = self.rect.maxY - offSet - constants.localOffset - constants.localOffset
            startPointYX = xValue
            startPointYY = yValue
            path.moveToPoint(CGPoint(x:xValue,y:yValue))
            var textRect:CGRect?
            var y = self.startingValueY
            for ;  y <= endingValueY ; yValue -= scaleY, y += incrementorY {
                text = "\(y)"
                println("drew \(y)")
                println("points: \(yValue)")
                textRect = CGRect(origin: CGPoint(x:xValue,y:yValue), size: text.sizeWithAttributes(attributes))
                text.drawInRect(textRect! , withAttributes:attributes)
            }

        
        }
        determineScaleAndIncrementorForHorziontal()
        drawUnitsHorizontally()
        determineScaleAndIncrementorForVertical()
        drawUnitsVertically()
    }
    func drawColor(){
        CGContextSaveGState(UIGraphicsGetCurrentContext())
        var path = UIBezierPath(rect: rect)
        backGroundColor.setFill()
        path.fill()
        CGContextRestoreGState(UIGraphicsGetCurrentContext())
    }
    
    func drawAxes(){
        drawColor()
        drawVerticalAxes()
        drawHorizontalAxes()
        drawUnitsOnAxes()
    }

}
