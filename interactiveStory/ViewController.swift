//
//  ViewController.swift
//  interactiveStory
//
//  Created by Kevin VanEvery on 7/10/16.
//  Copyright © 2016 Kevin VanEvery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    enum Error: ErrorType {
        case NoName
    }

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startAdventure" {
            
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw Error.NoName
                    }
                    if let pageController = segue.destinationViewController as? PageController {
                        pageController.page = Adventure.story(name)
                    }
                }
            } catch Error.NoName {
                let alertController = UIAlertController(title: "Name not provided", message: "Please input your name", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(action)
                
                presentViewController(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError()
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()

            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant = 48
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    //Mark - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

