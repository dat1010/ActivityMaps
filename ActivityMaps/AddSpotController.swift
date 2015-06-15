//
//  AddSpotController.swift
//  ActivityMaps
//
//  Created by David Tanner Jr on 6/9/15.
//  Copyright (c) 2015 David Tanner Jr. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AddSpotController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var spotImage: UIImageView! = UIImageView()
    var pickedImage = UIImage()
    var lat:CLLocationDegrees = 0.0
    var long:CLLocationDegrees = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
       // AddSpotController = UIModalPresentationStyle.OverCurrentContext

        
        closeButton.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        closeButton.setTitle(String.fontAwesomeIconWithName(.Close), forState: .Normal)

        //AddToFavorites.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        //AddToFavorites.setTitle("Add" + String.fontAwesomeIconWithName(.Star), forState: .Normal)
        
        //OpenInMaps.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        //OpenInMaps.setTitle(String.fontAwesomeIconWithName(.LocationArrow), forState: .Normal)
        
    }
    @IBAction func addSpot(sender: AnyObject) {
        let requestData = PFObject(className: "AddedSpots")
        //requestData["SpotType"] = txtRequestType.text
        //requestData["User"] = user
        //requestData["isAdded"] = 0
        
        requestData["lat"] = self.lat
        requestData["long"] = self.long
        var location:PFGeoPoint = PFGeoPoint(latitude: self.lat, longitude: self.long)
        requestData["location"] = location
        requestData["spotType"] = "skatepark"
        requestData["spotName"] = "test"
        let imageData = UIImagePNGRepresentation(self.pickedImage)
        let imageFile:PFFile = PFFile(data:imageData)
        requestData["image"] = imageFile
        //PFUser.currentUser()?.setObject(imageFile, forKey: "NewSpots")
        //PFUser.currentUser()?.saveInBackground()
        requestData.saveInBackground()
    }

    
    @IBAction func addImage(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    @IBAction func CloseModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info as NSDictionary
        var pickedImage = image.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        self.pickedImage = pickedImage
        let imageData = UIImagePNGRepresentation(pickedImage)
        spotImage.image = pickedImage
        let imageFile:PFFile = PFFile(data:imageData)
         //PFUser.currentUser()?.setObject(imageFile, forKey: "NewSpots")
        //PFUser.currentUser()?.saveInBackground()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
