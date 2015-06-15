//
//  ThirdViewController.swift
//  ActivityMaps
//
//  Created by David Tanner Jr on 6/13/15.
//  Copyright (c) 2015 David Tanner Jr. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ThirdViewController: UIViewController {

    @IBOutlet weak var lblRequest: UILabel!
    @IBOutlet weak var txtRequestType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load the data from parse
        lblRequest.text = "Request a spot type:"
        lblRequest.textColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRequest(sender: AnyObject) {
        if PFUser.currentUser() != nil
        {
            if !txtRequestType.text.isEmpty
            {
                let user:PFUser = PFUser.currentUser()!
                /*
                PFObject *postObject = [PFObject objectWithClassName:PAWParsePostsClassName];
                postObject[PAWParsePostTextKey] = self.textView.text;
                postObject[PAWParsePostUserKey] = user;
                */
                
                let requestData = PFObject(className: "Requests")
                requestData["SpotType"] = txtRequestType.text
                requestData["User"] = user
                requestData["isAdded"] = 0
                
                requestData.saveInBackgroundWithBlock {(success: Bool,error:NSError?) -> Void in
                    self.lblRequest.text = "Your request has been sent!"
                    self.lblRequest.textColor = UIColor.blackColor()
                }
                
            }else
            {
                lblRequest.text = "You must enter a spot type"
                lblRequest.textColor = UIColor.redColor()
            }
          
        }else{
            lblRequest.text = "You must be logged in to request a spot."
            lblRequest.textColor = UIColor.redColor()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
