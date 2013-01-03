//
//  KmedoidsBrain.swift
//  Kmedoids
//
//  Created by Sriharsha Sammeta on 17/03/15.
//  Copyright (c) 2015 Sriharsha Sammeta. All rights reserved.
//

import Foundation

protocol Cluster{
    var dimension:Int{get}
    var k:Int {get}
    var points:[[Float]]{get}
    func performClustering()->(clusters:[[[Float]]],midPoints:[[Float]])
    func getAxesPointsWithDimension()->(min1D:Float,max1D:Float,min2D:Float?,max2D:Float?)
    init(dimension: Int, k: Int, points: [[Float]])
}
//enum ClusterError{
//        case InvalidDataType
//        case InsufficientInputFor2D
//        case InsufficientInputForK
//        case NotYetImplementedKmeans
//}


struct Combinations{
    private static var combinations = [[Int]]()
    static func giveCombinations(arr: [Int],n: Int, r: Int) -> [[Int]]{
        combinations = [[Int]]()
        var data = [Int](count: r, repeatedValue: 0)
        combinationUtil(arr, data: data, start: 0, end: n - 1, index: 0, r: r)
        return combinations
    }
    static func combinationUtil(arr: [Int],var data: [Int],start: Int,end: Int,index: Int, r:Int){
        var temp = [Int]()
        if index == r {
            for var j = 0;j < r ;j++ {
                temp.append(data[j])
            }
            combinations.append(temp)
            return
        }
        for var i = start;i <= end && (end - i + 1) >= (r - index); i++ {
            data[index] = arr[i]
            combinationUtil(arr, data: data, start: i + 1, end: end, index: index + 1, r: r)
        
            
        }
    }
}

class Kmedoids:  Cluster{
    
    var dimension = 1
    var k = 1
    var points = [[Float]]()
    var medoids = [[Float]]()
    var clusters = [[[Float]]]()
    var savedClusters = [[[Float]]]()
    var savedMedoids = [[Float]]()
    var savedCost:Float = 0
    required init(dimension: Int, k: Int, points: [[Float]]){
        self.dimension = dimension
        self.k = k
        println("Dimension: \(dimension) \n k: \(k)")
        
        self.points = points
        println("Points: \(points)")
        for var i = 0;i < k ;i++ {
            medoids.append(self.points[i])
        }
        println("medoids: \(medoids)")
    }
    
    private func clusterize(){
        var minDist:Float = Float(Int.max)
        var minCluster = 0
        clusters = [[[Float]]]()
        for var i = 0;i < k; i++ {
            clusters.append([[Float]]())
        }
        println("clusterizing .....")
        if !points.isEmpty && !medoids.isEmpty {
            for point in points {
                minDist = Float(Int.max)
                minCluster = 0
                for var i = 0; i < k ; i++ {
                    var temp = self.findDistanceBetween(point1:point, point2: medoids[i])
                    if temp < minDist {
                        minDist = temp
                        minCluster = i
                    }
                }
                clusters[minCluster].append(point)
                println("clusters: \(clusters)")
            }
        }
    }
    
    private func findDistanceBetween(#point1:[Float], point2:[Float]) -> Float{

        if point1.count == point2.count{
            var dist: Float = 0
            for var i = 0 ; i < point1.count ; i++ {
                dist = dist + (point2[i] - point1[i]) * (point2[i] - point1[i])
            }
            dist = sqrt(dist)
            return dist
        }else{
            return -1
        }
    }
    
    private func calculateDistanceBetweenMedoidAndClusterOfPOints(#medoid: [Float],clusterPoints: [[Float]]) ->Float{
        var sum: Float = 0
        if !medoid.isEmpty && !clusterPoints.isEmpty {
            for point in clusterPoints {
                sum += findDistanceBetween(point1: medoid, point2: point)
            }
        }
        return sum
    }
    private func calculateTotalCost()->Float{
        var sum: Float = 0
        for var i = 0 ; i < k ; i++ {
            sum += calculateDistanceBetweenMedoidAndClusterOfPOints(medoid: medoids[i], clusterPoints: clusters[i])
        }
        return sum
    }
    private func createCombinations()->[[Int]]{
        var n = points.count
        var arr = [Int](count: n, repeatedValue: 0)
        for var i = 0 ; i < arr.count ; i++ {
            arr[i] = i
        }
        var r = k
        return Combinations.giveCombinations(arr, n: n, r: r)
    }
    private func performKMedoidsUsingCombinationsTool()->(clusters:[[[Float]]],midPoints:[[Float]]){
        savedCost = Float(Int.max)
        if points.isEmpty {
            return ([[[Float]]](),[[Float]]())
        }
       var combinations = createCombinations()
        for combination in combinations{
            medoids = [[Float]]()
            println("combination \(combination)")
            println("points \(points)")
            for val in combination {
                medoids.append(points[val])
            }
            
            clusterize()
            println("Medoids are:\n \(medoids)")
            var currentCost = calculateTotalCost()
            println("CurrentCost: \n \(currentCost)")
            
            if currentCost < savedCost {
                savedClusters = clusters
                savedMedoids = medoids
                savedCost = currentCost
            }
        }
        clusters = savedClusters
        medoids = savedMedoids
        
        println("Final cost:\n \(savedCost)")
        println("Final Cluster:\n \(clusters)")
        println("FInal Medoids: \n \(medoids)")
        
        return (clusters,medoids)
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
    func performClustering()->(clusters:[[[Float]]],midPoints:[[Float]]){
        return self.performKMedoidsUsingCombinationsTool()
    }
    
//    
//    func determinePointsElseNotifyError(arrayInString:[String],dimension:Int,k:Int)->(error:ClusterError?,points:[[Int]]?){
//        
//        var points = [[Int]]()
//        var arrayInInt = arrayInString.map(){
//            $0.toInt()
//        }
//        println("\(arrayInInt)")
//        for val in arrayInInt{
//            if val == nil {
//                return (ClusterError.InvalidDataType,nil)
//            }
//        }
//        if dimension == 2 {
//            if arrayInInt.count % 2 != 0 {
//
//                return (ClusterError.InsufficientInputFor2D,nil)
//            }
//        }
//        println("K:  \(k)  count: \(arrayInInt.count) ")
//        if ((dimension == 1 && k > arrayInInt.count) || (dimension == 2 && k > (arrayInInt.count / 2))) {
//            return (ClusterError.InsufficientInputForK,nil)
//        }
//        
//        points.removeAll(keepCapacity: false)
//        if dimension == 1 {
//            for val in arrayInInt{
//                points.append([val!])
//            }
//            
//        }else if dimension == 2{
//            for var i = 0; i < arrayInInt.count; i += 2 {
//                points.append([arrayInInt[i]!,arrayInInt[i + 1]!])
//            }
//        }
//            return(nil,points)
//    }


}
