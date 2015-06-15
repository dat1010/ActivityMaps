//
//  FourSquare.swift
//  ActivityMaps
//
//  Created by David Tanner Jr on 6/4/15.
//  Copyright (c) 2015 David Tanner Jr. All rights reserved.
//

import Foundation

class FourSquare {
    
    var lat:CLLocationDegrees
    var long:CLLocationDegrees
    
    init(long:CLLocationDegrees,lat:CLLocationDegrees){
        self.lat = lat
        self.long = long
    }
    
    
    func searchInLocation(spot:String) //-> NSDictionary
    {
        let query:String = String(format: "https://api.foursquare.com/v2/venues/search?client_id=FC5WDRT1UXXOBBNXGKLWO2TJY4WHXJX5W1UHLXJKSX0SWT2B&client_secret=3O3SXLEGICIJASCZG3XFEYMFU15QBNWVE2UDRW25I5WD2J50&v=20130815&ll=%02f,%02f&query=", long, lat) + spot
        println(query)
        
        let url = NSURL(string: query)
        let session = NSURLSession.sharedSession()
        var parseError : NSError?
        let task = session.downloadTaskWithURL(url!) {
            (loc:NSURL!, response:NSURLResponse!, error:NSError!) in
            let d = NSData(contentsOfURL: loc)!
            let parsedObject: AnyObject?  =
            NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            if let topLevelObject = parsedObject as? NSDictionary {
                if let response = topLevelObject.objectForKey("response") as? NSDictionary{
                    if let venues = response.objectForKey("venues") as? NSArray{
                        for spot in venues{
                            //self.object.append(spot)
                        }
                    }
                }

            }
            
            
        }
        /*(UIApplication.sharedApplication().delegate as! AppDelegate).incrementNetworkActivity()*/
        //task.resume()
        //return nil
    }
    
    func getAllSpots()
    {
        for spot in spotsArray{
            //todo
            //make a local dictionary and add each return in the dictionary
            self.searchInLocation(spot)
        }
    }
    
}
