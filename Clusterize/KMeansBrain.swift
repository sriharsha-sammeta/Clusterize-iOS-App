//
//  KMeansBrain.swift
//  Kmedoids
//
//  Created by Sriharsha Sammeta on 21/03/15.
//  Copyright (c) 2015 Sriharsha Sammeta. All rights reserved.
//

import Foundation
class kmeans: Cluster {
    var dimension = 1
    var k = 1
    var points = [[Float]]()
    var means = [[Float]]()
    var clusters = [[[Float]]]()

    required init(dimension: Int, k: Int, points: [[Float]]){
        self.dimension = dimension
        self.k = k
        self.points = points
        println("Dimension: \(dimension)")
        println("K: \(k)")
        println("Points:")
        println("\(points)")
        
        if k <= points.count {
            for var i = 0;i < k;i++ {
                means.append(points[i])
                }
        }
        println("Means are:")
        println("\(means)")
    }
    
    private func findDistanceBetween(#point1:[Float],point2:[Float]) -> Float{
        if point1.count == point2.count {
            var dist:Float = 0
            for var i = 0; i < point1.count; i++ {
                dist = dist + (point2[i] - point1[i]) * (point2[i] - point1[i])
            }
            dist = sqrt(dist)
            return dist
        }else{
        return -1
        }
    }
    private func clusterize(){
        var minDist:Float = Float(Int.max)
        var minCluster:Int = 0
        clusters = [[[Float]]]()
        for var i = 0;i < k ;i++ {
            clusters.append([[Float]]())
        }
        println("Clusterizing...")
        if !points.isEmpty && !means.isEmpty {
            for point in points {
                minDist = Float(Int.max)
                minCluster = 0
                for var i = 0;i < k; i++ {
                    var temp = findDistanceBetween(point1:point,point2:means[i])
                    if (temp < minDist){
                        minDist = temp
                        minCluster = i
                    }
                }
                clusters[minCluster].append(point)
                println(clusters)
            }
        }
    }
    private func calculateFutureMeans()->[[Float]]{
        println("calculating future means")
        var futureMeans = [[Float]]()
        for cluster in clusters{
            if !cluster.isEmpty{
                futureMeans.append(averageOfPoints(cluster)!)
            }
        }
        println("Future Means:")
        println("\(futureMeans)")
        return futureMeans
    }

    private func averageOfPoints(var points:[[Float]])->[Float]?{
        println("in average of points")
        if !points.isEmpty{
            var res  = [Float]()
            var temp:Float = 0
            for var i = 0; i < points[0].count; i++ {
                temp = 0
                for  point in points{
                    temp += point[i]
                }
                temp /= Float(points.count)
                res.append(temp)
            }
            println("res:\(res)")
            return res
        }else{
            println("return nil")
            return nil
        }
    }
  
    
    private func meansAreEqual(var mean1:[[Float]],var mean2:[[Float]])->Bool{
        if mean1.count == mean2.count{
            for var i = 0; i < mean1.count; i++ {
                for var j = 0; j < mean1[i].count;j++ {
                    if mean1[i][j] != mean2[i][j]{
                        return false
                    }
                }
            }
            return true
        }else{
            return false
        }
    }
   private func performKMeans(){
        clusterize()
        var futureMeans = calculateFutureMeans()
        println("Means:")
        println(means)
        if (!meansAreEqual(means, mean2: futureMeans)){
        means = futureMeans
        performKMeans()
        }
    }
    func performClustering()->(clusters:[[[Float]]],midPoints:[[Float]]){
        performKMeans()
        return (clusters,means)
    }
    
    func getAxesPointsWithDimension()->(min1D:Float,max1D:Float,min2D:Float?,max2D:Float?){
        var xArray = [Float]()
        var yArray = [Float]()
        for point in points{
            xArray.append(point[0])
            if dimension == 2 {
                yArray.append(point[1])
            }
            
        }
        sort(&xArray)
        if yArray.isEmpty{
            return (xArray[0],xArray.last! +  5,nil,nil)
        }else {
            sort(&yArray)
            return (xArray[0],xArray.last! + 5,yArray[0],yArray.last! + 5)
        }
    }
}