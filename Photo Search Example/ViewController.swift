//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Ori's Air on 3/2/15.
//  Copyright (c) 2015 Thinkful. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    

    @IBOutlet weak var searchErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //instantiate a gray Activity Indicator View
        var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        //add the activity to the ViewController's view
        view.addSubview(activityIndicatorView)
        //position the Activity Indicator View in the center of the view
        activityIndicatorView.center = view.center
        //tell the Activity Indicator View to begin animating
        activityIndicatorView.startAnimating()
        
        searchInstagramByHashtag("codes")
        activityIndicatorView.removeFromSuperview()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        searchBar.resignFirstResponder()
        searchInstagramByHashtag(searchBar.text)
         
    }
    
    func searchInstagramByHashtag(searchString:String) {
        if searchString.rangeOfString(" ") != nil {
            println("Please enter a single search term with no spaces")
            searchErrorLabel.text = "Please enter a single search term with no spaces"
        }
        else {
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=01b197ad6566448485c07e0af8db03fe",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //  println("JSON: " + responseObject.description)
                if let dataArray = responseObject["data"] as? [AnyObject] {
                    var urlArray:[String] = []                  //1
                    for dataObject in dataArray {               //2
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String { //3
                            urlArray.append(imageURLString)     //4
                        }
                    }
                    println(urlArray)  //5
                    let imageWidth = self.view.frame.width
                    self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                    for var i = 0; i < urlArray.count; i++ {
                        //                        let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)         //1
                        //                        if let imageDataUnwrapped = imageData {                                     //2
                        //                            let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped))   //3
                        //                            imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)               //4
                        let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth, imageWidth))     //1
                        imageView.setImageWithURL( NSURL(string: urlArray[i]))
                        self.scrollView.addSubview(imageView)                                        //5
                        //    }
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        } )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

