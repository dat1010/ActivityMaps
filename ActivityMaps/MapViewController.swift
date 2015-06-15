//
//  MapViewController.swift
//  ActivityMaps
//
//  Created by David Tanner Jr on 6/4/15.
//  Copyright (c) 2015 David Tanner Jr. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    @IBOutlet weak var menuItem: UIBarButtonItem!
    var locationManager = CLLocationManager()
    var objects = [AnyObject]()
    var didFindMyLocation = false
    var lat:CLLocationDegrees = 0.0
    var long:CLLocationDegrees = 0.0
    var Dropobj = DropDownListView()
    
    var places = [MapMarker]()
    
    @IBOutlet weak var addSpot: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHamburger()
        
        addSpot.titleLabel?.font = UIFont.fontAwesomeOfSize(45)
        addSpot.setTitle(String.fontAwesomeIconWithName(.PlusCircle), forState: .Normal)
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: mapZoom)
        mapView.camera = camera
        view.addSubview(addSpot)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    
    
    func buttonAction(sender:UIButton!)
    {
        println("Button tapped")
        self.performSegueWithIdentifier("AddSpotView", sender:self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
        }
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 11)
            myLocation.coordinate.latitude
            myLocation.coordinate.longitude
            didFindMyLocation = true
            self.lat = myLocation.coordinate.latitude
            self.long = myLocation.coordinate.longitude
            self.getSpotsFromParse(lat, long: long)
            for spot in spotsArray
            {
                 self.searchInLocation(self.long, lat:self.lat, spotType: spot)
            }
           
            
        }
    }

    

    
    
    func updateLocation(running: Bool){
        //let mapView = self.view as! GMSMapView
        let status = CLLocationManager.authorizationStatus()
        if running {
            if CLAuthorizationStatus.AuthorizedWhenInUse == status{
                locationManager.startUpdatingLocation()
                mapView.myLocationEnabled = true
               // mapView.settings.myLocationButton = true
            }else{
                locationManager.stopUpdatingLocation()
                mapView.myLocationEnabled = false
                mapView.settings.myLocationButton = false
            }
           
        }
    }
    
    


   override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //updateLocation(true)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locations.last
    }
    
    func setHamburger(){
        menuItem.setTitleTextAttributes(attributes, forState: .Normal)
        menuItem.title = String.fontAwesomeIconWithName(.Bars)
        
    }

    
    var mapRadius: Double {
        get {
            let region = mapView.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
            return max(horizontalDistance, verticalDistance)*0.5
        }
    }
    
    
    func searchInLocation(long:CLLocationDegrees, lat:CLLocationDegrees,spotType:String) //-> NSDictionary
    {
        let query:String = String(format: "https://api.foursquare.com/v2/venues/search?client_id=FC5WDRT1UXXOBBNXGKLWO2TJY4WHXJX5W1UHLXJKSX0SWT2B&client_secret=3O3SXLEGICIJASCZG3XFEYMFU15QBNWVE2UDRW25I5WD2J50&v=20130815&ll=%02f,%02f&query=", lat, long) + spotType
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
                            let test = spot as! NSDictionary
                            var id:String = (test.objectForKey("id") as? String)!
                            var name:String = (test.objectForKey("name") as? String)!
                            var location:NSDictionary = (test.objectForKey("location") as? NSDictionary)!
                            var lat:CLLocationDegrees = (location.objectForKey("lat") as? CLLocationDegrees)!
                            var lng:CLLocationDegrees = (location.objectForKey("lng") as? CLLocationDegrees)!
                            var spotStruct:MapMarker = MapMarker(id:id,position:CLLocationCoordinate2DMake(lat, lng),name:name,type:spotType)
                            //var id:String = spot.objectForKey("id")
                            //println(lat)
                            //println(spotStruct.id + spotStruct.name)
                            self.places.append(spotStruct)
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            (UIApplication.sharedApplication().delegate as! AppDelegate).decrementNetworkActivity()
                            self.mapView.reloadInputViews()
                            if self.places.count > 0{
                                for spot in self.places{
                                    let marker = GMSMarker()
                                    marker.position = spot.position
                                    marker.title = spot.name
                                    marker.appearAnimation = kGMSMarkerAnimationPop
                                    marker.icon = UIImage(named: spot.type)
                                    //marker.snippet = "Population: 8,174,100"
                                    marker.map = self.mapView
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).incrementNetorwkActivity()
        task.resume()
    }
    
    func getSpotsFromParse(lat:CLLocationDegrees,long:CLLocationDegrees)
    {
        var lt = Double(round(10000*lat)/10000)
        var lng = Double(round(10000*long)/10000)
        var descLocation: PFGeoPoint = PFGeoPoint(latitude: lat, longitude: long)
        
        println(lt)
        var query = PFQuery(className: "AddedSpots")
        query.whereKey("location", nearGeoPoint: descLocation, withinMiles: 20)
        query.findObjectsInBackgroundWithBlock{ (objects: [AnyObject]?, error: NSError?) -> Void in
            if objects != nil && error == nil
            {
                var spots = objects as! [NSDictionary]
                for spot in spots {
                    var id:String = (spot.objectForKey("id") as? String)!
                    var name:String = (spot.objectForKey("name") as? String)!
                    var location:NSDictionary = (spot.objectForKey("location") as? NSDictionary)!
                    var lat:CLLocationDegrees = (location.objectForKey("lat") as? CLLocationDegrees)!
                    var lng:CLLocationDegrees = (location.objectForKey("lng") as? CLLocationDegrees)!
                    var spotStruct:MapMarker = MapMarker(id:id,position:CLLocationCoordinate2DMake(lat, lng),name:name,type:spotType)
                    //var id:String = spot.objectForKey("id")

                    self.places.append(spotStruct)
                }
            }else
            {
                println("An Error Accurd")
            }
        }
        
        /*
       
       query.getFirstObjectInBackgroundWithBlock {(object:PFObject?, error:NSError?) ->Void in
            if object != nil && error == nil
            {
                let spot = object?.objectForKey("lat") as! CLLocationDegrees
                println("The lat is: ")
                println(spot)
            }else
            {
                println(error)
            }
        }*/
    }
    
    
    @IBAction func refreshMap(sender: AnyObject) {
         //fetchNearbyPlaces(mapView.camera.target)
    }

    func addButton(mapView:GMSMapView!)
    {
        if PFUser.currentUser() != nil
        {
            //addSpot.frame = CGRectMake(mapView.bounds.size.width-70,mapView.bounds.size.height-30, 100, 20)
            //addSpot.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin
        
        //button.setTitle("Test Button", forState: UIControlState.Normal)
            addSpot.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
            addSpot.setTitle(String.fontAwesomeIconWithName(.PlusCircle), forState: .Normal)
            //addSpot.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            //view.addSubview(addSpot)
        }
    }
    
    

    
    @IBAction func dropDownSelected(sender: AnyObject) {
       Dropobj.fadeOut()
        
        Dropobj = DropDownListView(title:"Spots",options: spotsArray, xy:CGPointMake(16, 58) ,size:CGSizeMake(287, 330) ,isMultiple:false)
        Dropobj.showInView(self.view, animated: true)
        Dropobj.SetBackGroundDropDwon_R(0.0, g: 108.0, b: 194.0, alpha: 0.70)
    }
    
    /*- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    /*----------------Get Selected ValueSingle selection]-----------------*/
    _lblSelectedCountryNames.text=[arryList objectAtIndex:anIndex];
    }*/
    

    
    // MARK: - Navigation
    
     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender as? UIButton == self.addSpot
        {
            let long = self.long
            let lat = self.lat
            (segue.destinationViewController as! AddSpotController).long = long
            (segue.destinationViewController as! AddSpotController).lat  = lat
        }
        

        
    }
    
    

}
