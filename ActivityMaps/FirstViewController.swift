
//
//  FirstViewController.swift
//  ActivityMaps
//
//  Created by David Tanner Jr on 5/28/15.
//  Copyright (c) 2015 David Tanner Jr. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FirstViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {


   
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loginButtonMessage: UIButton!
    @IBOutlet weak var loginMessage: UILabel!
    @IBOutlet weak var profileIcon: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profileIcon.setTitleTextAttributes(attributes, forState: .Normal)
        profileIcon.title = String.fontAwesomeIconWithName(.User)
        
        loginButtonMessage.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        loginButtonMessage.setTitle("Login " + String.fontAwesomeIconWithName(.SignIn), forState: .Normal)
        
        logoutButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        logoutButton.setTitle("Logout " + String.fontAwesomeIconWithName(.SignOut), forState: .Normal)
        self.loginMessage.text = "User email: "
        //query.includeKey("user") as? String
        
    }
    
    @IBAction func LogIn(sender: AnyObject) {
        if PFUser.currentUser() == nil
        {
            var loginCtrl = PFLogInViewController()
            loginCtrl.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton |
                PFLogInFields.Facebook | PFLogInFields.SignUpButton | PFLogInFields.DismissButton
            
            loginCtrl.facebookPermissions = ["friends_about_me"]
            loginCtrl.delegate = self
            var signupCtrl = PFSignUpViewController()
            signupCtrl.delegate = self
            loginCtrl.signUpController = signupCtrl
            
            self.presentViewController(loginCtrl ,animated:true,completion:nil)
            var query = PFQuery(className:"User")
            //self.loginMessage.text = "User email: " + query.includeKey("user") as? String
        }
    }
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        loginMessage.text = "User logged out."
    }

    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if count(username) > 0 && count(password) > 0{
            return true
        }else{
            var alert = UIAlertView(title: "Missing login info", message: "Make sure you fill in the username and password", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.loginMessage.text = user.email
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Login Failed")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        println("Login canceled by user")
    }

    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.loginMessage.text = user.email
    }

}

