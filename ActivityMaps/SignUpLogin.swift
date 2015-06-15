//
//  SignUpLogin.swift
//  ActivityMaps
//
//  Created by David Tanner Jr on 6/6/15.
//  Copyright (c) 2015 David Tanner Jr. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpLogin: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil
        {
            var loginCtrl = PFLogInViewController()
            loginCtrl.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton
            loginCtrl.delegate = self
            
            var signupCtrl = PFSignUpViewController()
            signupCtrl.delegate = self
            loginCtrl.signUpController = signupCtrl
            
            self.presentViewController(loginCtrl ,animated:true,completion:nil)
        }
        
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
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        println("Login Failed")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        println("Login canceled by user")
    }

}
