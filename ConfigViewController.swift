//
//  ConfigViewController.swift
//  QEMobile
//
//  Created by Justin Owens on 3/12/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import UIKit



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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
       super.viewWillDisappear(animated)
  
    }
   
    
    
   
    
    @IBAction func btnAccept(sender: AnyObject) {
        didCancel = "no"
        let alertView = UIAlertController(title: "Error", message: "Prefix cannot exceed two characters.", preferredStyle: .Alert)
       
        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        if txtPrefixOne.text!.characters.count > 2 || txtPrefixTwo.text!.characters.count > 2 || txtPrefixThree.text!.characters.count > 2 || txtPrefixFour.text!.characters.count > 2 {
             presentViewController(alertView, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier("UnwindConfig", sender: self)
            var configCancelSegue = 1
           print("performed segue from accept", terminator: "")
        }
        
        
       
    }
    /*@IBAction func btnCancel(sender: AnyObject) {
        didCancel = "yes"
        
        self.performSegueWithIdentifier("segueTest", sender: self)
        println("performed segue from cancel")
        
    }*/
    
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
