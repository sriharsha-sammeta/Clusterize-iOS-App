//
//  InputTableViewController.swift
//  Kmedoids
//
//  Created by Sriharsha Sammeta on 20/03/15.
//  Copyright (c) 2015 Sriharsha Sammeta. All rights reserved.
//

import UIKit

class InputTableViewController: UITableViewController,UITextViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Outlets and Actions
    
    private var dimension: Int = 1
    private var k: Int = 1
    private var points = [[Int]]()
    private enum ClusterAlgorithm:String{
        case kmeans = "Mean"
        case kmedoids = "Medoid"
    }
    private var chosenClusterAlgorithm:ClusterAlgorithm = ClusterAlgorithm.kmedoids
    var shouldSegueToClustersBeAllowed = false
    var textFromPointTextView:String = ""
    
    enum Errors: String{
        case InvalidDataType = "Points can only be Integer values ex: 1,2,3"
        case InsufficientInputFor2D = "2-Dimension data must have even number of values"
        case InsufficientInputForK = "Number of Clusters (K) is more than number of points"
        case NotYetImplementedKmeans = "K-Means Yet to be implemented,only logic porting reuired !"
        case InputEmpty = "Value for Points cannot be left empty !"
    }
    struct VCConstants{
        private static let SegueIdentifierForCluster = "clusterize"
    }
    func raiseErrorUsingMessage(error:Errors){
        points.removeAll(keepCapacity: false)
        var alertController = UIAlertController(
            title: "OOPS Erroneous input bro :( !",
            message: error.rawValue,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(
            title: "I Accept the Error",
            style: UIAlertActionStyle.Default,
            handler: nil))
        presentViewController(alertController,
            animated: true,
            completion: nil)
    }
    
    func determinePointsElseNotifyError(){
        println("In func determine Points else notify err")
        
        shouldSegueToClustersBeAllowed = false
        if textFromPointTextView.isEmpty{
            raiseErrorUsingMessage(Errors.InputEmpty)
            return
        }
        
        var arrayInString = textFromPointTextView.componentsSeparatedByString(",")
        println("after separting by , \(arrayInString)")
        var arrayInInt = arrayInString.map(){
            $0.toInt()
        }
        println("\(arrayInInt)")
        for val in arrayInInt{
            if val == nil {
                raiseErrorUsingMessage(Errors.InvalidDataType)
                return
            }
        }
        if dimension == 2 {
            if arrayInInt.count % 2 != 0 {
                raiseErrorUsingMessage(Errors.InsufficientInputFor2D)
                return
            }
        }
        println("K:  \(k)  count: \(arrayInInt.count) ")
        if ((dimension == 1 && k > arrayInInt.count) || (dimension == 2 && k > (arrayInInt.count / 2))) {
            raiseErrorUsingMessage(Errors.InsufficientInputForK)
            return
        }
        
        points.removeAll(keepCapacity: false)
        if dimension == 1 {
            for val in arrayInInt{
                points.append([val!])
            }
            
        }else if dimension == 2{
            for var i = 0; i < arrayInInt.count; i += 2 {
                points.append([arrayInInt[i]!,arrayInInt[i + 1]!])
            }
        }
        shouldSegueToClustersBeAllowed = true
    }
    
    
    
    @IBOutlet weak var kValueLabel: UILabel!
    @IBOutlet weak var pointsTextView: UITextView! {
        didSet{
            pointsTextView.delegate = self
            pointsTextView.text = ""
        }
    }
    
   

    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.pointsTextView.resignFirstResponder()
    }
    func textViewDidEndEditing(textView: UITextView) {
        println("TextView editing ended !")
        println(textView.text)
        pointsTextView.resignFirstResponder()
        if let text = textView.text {
            textFromPointTextView =  text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            determinePointsElseNotifyError()
        }
    }
    @IBAction func changeDimensionBySegmentedControl(sender: UISegmentedControl) {
        dimension = sender.selectedSegmentIndex + 1
    }
    
    @IBAction func changeKBySlider(sender: UISlider) {
        k = Int(sender.value)
        sender.value = Float(k)
        kValueLabel.text = "(\(k))"
    }
    
    @IBAction func changeAlgorithmByUsingSwitch(sender: UISwitch) {
        chosenClusterAlgorithm = sender.on ? ClusterAlgorithm.kmedoids : ClusterAlgorithm.kmeans
    }

    @IBAction func clusterize(sender: UIButton) {
        textViewDidEndEditing(pointsTextView)
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let identifier = identifier{
            switch identifier{
            case VCConstants.SegueIdentifierForCluster:
                println("in here")
                return shouldSegueToClustersBeAllowed
            default: break
            }
        
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
              case VCConstants.SegueIdentifierForCluster:
                if let cvc  = segue.destinationViewController as? ClusterViewController{
                    func convert(arrIntToFloat arr2Int:[[Int]])->[[Float]]{
                        var pointsFLoat = [[Float]]()
                        for points in arr2Int {
                            pointsFLoat.append(points.map{
                                Float($0)
                                })
                        }
                        return pointsFLoat
                    }
                    if chosenClusterAlgorithm == ClusterAlgorithm.kmedoids {
                        cvc.brain = Kmedoids(dimension: self.dimension, k: self.k, points: convert(arrIntToFloat: self.points))
                        cvc.algorithmName = chosenClusterAlgorithm.rawValue

                    }else if chosenClusterAlgorithm == ClusterAlgorithm.kmeans{
                        cvc.brain = kmeans(dimension: self.dimension, k: self.k, points: convert(arrIntToFloat: self.points))
                        cvc.algorithmName = chosenClusterAlgorithm.rawValue
                        
//                        var alertController = UIAlertController(
//                            title: "KMeans Yet to be implemented",
//                            message: "Will soon port my java code to swift :)",
//                            preferredStyle: UIAlertControllerStyle.Alert)
//                        
//                        alertController.addAction(UIAlertAction(
//                            title: "Apology Accepted",
//                            style: UIAlertActionStyle.Default,
//                            handler: nil))
//                        presentViewController(alertController,
//                            animated: true,
//                            completion: nil)

                    }
                }
            default:
                break
                
            }
            
        }
        
    }

//            case "1d cluster":
//                if let cvc = segue.destinationViewController as? ClusterViewController{
//                    cvc.brain = Kmedoids(dimension: 1, k: 3, points: [[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],])
//                    //                        cvc.brain = Kmedoids(dimension: 2, k: 3, points: [[2,10],[2,5],[8,4],[5,8],[7,5],[6,7],[1,2],[4,9]])
//                }
//            case "2d cluster":
//                if let cvc = segue.destinationViewController as? ClusterViewController{
//                    //                        cvc.brain = Kmedoids(dimension: 1, k: 3, points: [[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],])
//                    cvc.brain = Kmedoids(dimension: 2, k: 3, points: [[2,10],[2,5],[8,4],[5,8],[7,5],[6,7],[1,2],[4,9]])
//                }
    
    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("row1", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
