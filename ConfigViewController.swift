//
//  ConfigViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 3/12/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ConfigViewController: UIViewController {
   
    @IBOutlet weak var txtPrefixOne: UITextField!
    @IBOutlet weak var txtPrefixTwo: UITextField!
    @IBOutlet weak var txtPrefixThree: UITextField!
    @IBOutlet weak var txtPrefixFour: UITextField!
    var didCancel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
       
    }
    
   @IBAction func btnAccept(sender: AnyObject) {
        didCancel = "no"
        if txtPrefixOne.text!.characters.count > 2 || txtPrefixTwo.text!.characters.count > 2 || txtPrefixThree.text!.characters.count > 2 || txtPrefixFour.text!.characters.count > 2 {
            Utils.showAlertOnVC(self, alertType: "ExcessPrefix")
        } else {
            self.performSegueWithIdentifier("UnwindConfig", sender: self)
        }
    }
    
    
   
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        txtPrefixOne.resignFirstResponder()
        txtPrefixTwo.resignFirstResponder()
        txtPrefixThree.resignFirstResponder()
        txtPrefixFour.resignFirstResponder()
    }
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
   
}
