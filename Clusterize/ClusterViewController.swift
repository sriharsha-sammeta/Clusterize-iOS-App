//
//  ViewController.swift
//  Cluster
//
//  Created by Sriharsha Sammeta on 15/03/15.
//  Copyright (c) 2015 Sriharsha Sammeta. All rights reserved.
//

import UIKit



class ClusterViewController: UIViewController,ClusterViewDataSource,UIPopoverPresentationControllerDelegate{

 struct conversions{
    static func convert(#arr3Float:[[[Float]]])->[[[CGFloat]]]{
            var clusters = [[[CGFloat]]]()
            var clusterCGFloat = [[CGFloat]]()
            for cluster  in arr3Float{
                for points in cluster{
                    clusterCGFloat.append(points.map{
                        CGFloat($0)
                    })
                }
                clusters.append(clusterCGFloat)
                clusterCGFloat.removeAll(keepCapacity: false)
            }
            return clusters
        
        }
        
    static func convert(#arr2Float:[[Float]])->[[CGFloat]]{
            
            var pointsCGFLoat = [[CGFloat]]()
            for points in arr2Float {
                pointsCGFLoat.append(points.map{
                    CGFloat($0)
                })
            }
            return pointsCGFLoat
        }
    static func convert(#arr2CGFloat:[[CGFloat]])->[[Float]]{
            var pointsFLoat = [[Float]]()
            for points in arr2CGFloat {
                pointsFLoat.append(points.map{
                        Float($0)
                    })
            }
            return pointsFLoat
        }
    }
    
    var clusters:[[[CGFloat]]]!
    var midPoints:[[CGFloat]]!
    var result:(min1D:CGFloat,max1D:CGFloat,min2D:CGFloat,max2D:CGFloat)!
    var brain: Cluster!{
        didSet{
            result = getAxesPointsWithDimension()
            var temp = getClustersAndMidPoints()
            clusters = temp.clusters
            midPoints = temp.midPoints
        }
    }
    var algorithmName:String?


    
    func getClustersAndMidPoints()->(clusters:[[[CGFloat]]],midPoints:[[CGFloat]]){
        if clusters != nil && midPoints != nil{
            return (clusters,midPoints)
        }
        var (clustersFloat,midPointsFloat) = brain.performClustering()
        clusters = conversions.convert(arr3Float: clustersFloat)
        midPoints = conversions.convert(arr2Float: midPointsFloat)
        println("from view controller cluster -> \(clusters)")
        println("from view controller midPoints -> \(midPoints)")
        return (clusters,midPoints)
    }
    func getAxesPointsWithDimension()->(min1D:CGFloat,max1D:CGFloat,min2D:CGFloat,max2D:CGFloat){
        if result != nil {
            return result
        }
            var temp = brain.getAxesPointsWithDimension()
            result = (CGFloat(temp.min1D),CGFloat(temp.max1D),CGFloat(temp.min2D ?? temp.min1D),CGFloat(temp.max2D ?? temp.max1D))
       return result
    }
    

    
    @IBOutlet weak var graphView: ClusterGraphView!{
        didSet{
            graphView.dataSource = self
            if brain.dimension == 1 {
                graphView.yPos = 1
            }else{
                graphView.yPos = 2.25
            }
        }
    }
    
    private struct History{
        static let SegueIdentifier = "show details of cluster"
    }

  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch identifier{
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController{
                    if let ppc = tvc.popoverPresentationController{
                        ppc.delegate = self
                    }
                    tvc.text = "Final Clusters: \n\n"
                    for var i = 0; i < clusters.count; i++ {
                        tvc.text += " Cluster \(i): "
                        tvc.text += "\(clusters[i]) \n"
                    }
                    var temp = algorithmName ?? "Mid Point"
                    tvc.text += "\nFinal \(temp): \n\n"
                    for var i = 0; i < midPoints.count; i++ {
                        tvc.text += " \(temp) \(i): "
                        tvc.text += "\(midPoints[i]) \n"
                    }
                    
                }
            default:
                break
            }
            
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }



}

