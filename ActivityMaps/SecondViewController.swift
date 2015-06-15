//
//  SecondViewController.swift
//  ActivityMaps
//
//  Created by David Tanner Jr on 5/28/15.
//  Copyright (c) 2015 David Tanner Jr. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {

    @IBOutlet weak var favorite: UITabBarItem!
    var Dropobj = DropDownListView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        favorite.setTitleTextAttributes(attributes, forState: .Normal)
        favorite.title = String.fontAwesomeIconWithName(.Star)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func favoritesSelect(sender: AnyObject) {
        Dropobj.fadeOut()
        Dropobj = DropDownListView(title:"Spots",options: spotsArray, xy:CGPointMake(16, 58) ,size:CGSizeMake(287, 330) ,isMultiple:true)
        Dropobj.showInView(self.view, animated: true)
        Dropobj.SetBackGroundDropDwon_R(0.0, g: 108.0, b: 194.0, alpha: 0.70)
        
    }

}

