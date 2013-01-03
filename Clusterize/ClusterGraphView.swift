//
//  ClusterGraphView.swift
//  Cluster
//
//  Created by Sriharsha Sammeta on 15/03/15.
//  Copyright (c) 2015 Sriharsha Sammeta. All rights reserved.
//

import UIKit

protocol ClusterViewDataSource{
//    func getRectToDraw()->CGRect
    func getAxesPointsWithDimension()->(min1D:CGFloat,max1D:CGFloat,min2D:CGFloat,max2D:CGFloat)
    func getClustersAndMidPoints()->(clusters:[[[CGFloat]]],midPoints:[[CGFloat]])

}


class ClusterGraphView: UIView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBInspectable
    var backGroundColor:UIColor?{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var foreGroundColor:UIColor?{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var offSet:CGFloat = 30{
        didSet{
            setNeedsDisplay()
        }
    }
    
    var arrColor = [UIColor.blueColor(),UIColor.redColor(),UIColor.greenColor(),UIColor.yellowColor(),UIColor.purpleColor(),UIColor.magentaColor(),UIColor.blackColor(),UIColor.brownColor()]
    
    var dataSource: ClusterViewDataSource!
    var yPos:CGFloat?
    
    struct Constants{
        private static let CircleRadius:CGFloat = 5
    }
    enum CircleStyle{
        case fill
        case stroke
    }
    func drawCirclesUsingArrayOfCoordinates(array:[[CGFloat]],decideForStrokeUsingArray midPoints:[[CGFloat]], clusterNumber:Int, andAxes axes: ClusterGrapher,byTheColor color:UIColor){
        func drawCircleAt(x:CGFloat,y:CGFloat,#byStyle:CircleStyle?){
           let path = UIBezierPath(arcCenter: CGPoint(x: x,y:y), radius: Constants.CircleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
            if let style = byStyle{
                switch style{
                case .fill:
                    color.setFill()
                    path.fill()
                case .stroke:
                    color.setStroke()
                    path.stroke()
                }
            }
        }
        var coordinate = [CGFloat]()
        for  var i = 0 ;i < array.count ; i++ {
            coordinate = array[i]
            coordinate.append(axes.startingValueY)
            var x = axes.startPointXX + ((coordinate[0] - 0.75) * (axes.scaleX / axes.incrementorX))
            //yPos shoudld be 1(for 1D) or 2.25 (for 2D )
            var y = axes.startPointYY - ((coordinate[1] - yPos!) * (axes.scaleY / axes.incrementorY))
            
            var notMidPoint = true
            for val in midPoints{
                if val == array[i]{
                    notMidPoint = false
                    break
                }
            }
            println("Circles at x: \(x)  y: \(y)")
            if notMidPoint{
                drawCircleAt(x, y, byStyle: CircleStyle.fill)
            }
        }

            coordinate = midPoints[clusterNumber]
            coordinate.append(axes.startingValueY)
            var x = axes.startPointXX + ((coordinate[0] - 0.75) * (axes.scaleX / axes.incrementorX))
            //yPos shoudld be 1(for 1D) or 2.25 (for 2D )
            var y = axes.startPointYY - ((coordinate[1] - yPos!) * (axes.scaleY / axes.incrementorY))
            
            println("MidPoints  at x: \(x)  y: \(y)")
            drawCircleAt(x, y, byStyle: CircleStyle.stroke)
        
        
    }
    
    override func drawRect(rect: CGRect) {
        
//        var axes = ClusterGrapher(rect: dataSource.rect, backGroundColor: backGroundColor!, foreGroundColor: foreGroundColor!, offSet: offSet,startingValueX:dataSource.startingValueX,endingValueX:dataSource.endingValueX,startingValueY:dataSource.startingValueY,endingValueY:dataSource.endingValueY)
        
//        var axes = ClusterGrapher(rect: self.bounds, backGroundColor: backGroundColor!, foreGroundColor: foreGroundColor!, offSet: offSet,startingValueX:1,endingValueX:10,startingValueY:1,endingValueY:70)
        
        var values = dataSource.getAxesPointsWithDimension()
        
//        println("-------rect Height------\(dataSource.getRectToDraw())------")
        println("----nrmal height---\(self.bounds.height)-----")
        println("values-> \(values)")
        var axes = ClusterGrapher(rect: self.bounds, backGroundColor: backGroundColor!, foreGroundColor: foreGroundColor!, offSet: offSet, startingValueX: values.min1D, endingValueX: values.max1D, startingValueY: values.min2D, endingValueY: values.max2D)
        
        axes.drawAxes()
//        var array:[[[CGFloat]]] = [[[1,2],[5,8],[5,47],[19,51]]]
//        var midPoints:[[CGFloat]] = [[5,8]]
        
        
//        drawCirclesUsingArrayOfCoordinates(dataSource.arr, andAxes: axes, byTheColor: dataSource.arrColor)
        
        var (clusters,midPoints) = dataSource.getClustersAndMidPoints()
        println("clusters from view -> \(clusters)")
        println("midPoints:-> \(midPoints)")
        for var i = 0 ;i < clusters.count ; i++ {
            drawCirclesUsingArrayOfCoordinates(clusters[i], decideForStrokeUsingArray: midPoints,clusterNumber:i, andAxes: axes, byTheColor: arrColor[i % arrColor.count])
        }
    
    }
    


}
