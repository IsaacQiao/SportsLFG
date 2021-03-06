//
// File   : RegisterViewController.swift
// Author : Charles Li
// Date created: Oct.20 2015
// Date edited : Oct.31 2015
// Description: This is class is used by the register view controller
//              and handles user registration

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    // MARK: Properties
    
    
    @IBOutlet weak var userNewEmail : UITextField!
    @IBOutlet weak var userNewPassword: UITextField!
    @IBOutlet weak var userNewPasswordConfirm: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //set all the textfields's delegate to its view controller
        self.userNewEmail.delegate = self
        self.userNewPassword.delegate = self
        self.userNewPasswordConfirm.delegate = self
        
    }
    
    //This method  dismisses keyboard on return key press
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    //This method dismisses keyboard by touching to anywhere on the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    //This method returns true if the user email is valid and false if not
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    // MARK: Actions
    
    @IBAction func reigsterNewUser(sender: UIButton) {
        
        var email     = userNewEmail.text
        let password  = userNewPassword.text
        let confirm   = userNewPasswordConfirm.text
        print(email!)
        email = email!.lowercaseString
        print(email!)
        
        /////////////////////////
        //User Input Validation//
        /////////////////////////
        
        // This checks if password and confirm password match and alerts the user if they are different
        if((password) != confirm)
        {
            let alert = UIAlertController(
                title:   NSLocalizedString("Error", comment: "account success note title"),
                message: NSLocalizedString("Passwords do not match", comment: "password errors"),
                preferredStyle : UIAlertControllerStyle.Alert
            )
            
            let cancelAction = UIAlertAction(title :"Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true , completion: nil)
            return
        }
        
        // This checks if there is any empty field and alerts the user if there is one or more
        if(email!.isEmpty    == true ||
            password!.isEmpty == true ||
            confirm!.isEmpty  == true )
        {
            let alert = UIAlertController(
                title:   NSLocalizedString("Error", comment: "account success note title"),
                message: NSLocalizedString("Empty field", comment: "password errors"),
                preferredStyle : UIAlertControllerStyle.Alert
            )
            
            let cancelAction = UIAlertAction(title :"Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true , completion: nil)
            return
        }
        
        // This validate email format and alerts the user if email format is invalid
        if(!(isValidEmail(email!)))
        {
            let alert = UIAlertController(
                title:   NSLocalizedString("Error", comment: "erro title "),
                message: NSLocalizedString("it's not a valid email address", comment: "email error"),
                preferredStyle : UIAlertControllerStyle.Alert
            )
            
            let cancelAction = UIAlertAction(title :"Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true , completion: nil)
            return
        }
        
        
        /////////////////////////////////
        // Kinvey New User Registration//
        /////////////////////////////////
        
        
        NSLog("check")
        NSLog(email!)
        NSLog(password!)
        
        //Add custom attributes to KCSUser object
        
        
        //This is the user registration method from the Kinvey API
        KCSUser.userWithUsername(
            email!,
            password: password!,
            fieldsAndValues:[KCSUserAttributeEmail:email!],
            withCompletionBlock: { (user: KCSUser!, errorOrNil: NSError!, result: KCSUserActionResult) -> Void in
                if errorOrNil == nil {
                    //was successful!
                    NSLog("successful")
                    let alert = UIAlertController(
                        title: NSLocalizedString("Account Creation Successful", comment: "account success note title"),
                        message: NSLocalizedString("User created. Welcome! You will receive an email to verify the registration before you can log on", comment: "account success message body"),
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    
                  let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (Default) -> Void in
                    
                    //pop the current view and go back to login screen
                    self.navigationController?.popViewControllerAnimated(true)
                  })
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true , completion: nil)
                    return
                    
                    
                } else {
                    NSLog("error")
                    //there was an error with the create
                    //this checks what kind of error it is and it prints the info to the console
                    errorOrNil.userInfo["Kinvey.ExecutedHooks"]
                    let errorObject = errorOrNil.userInfo["Kinvey.ExecutedHooks"]
                    print(errorObject)
                    let message = errorOrNil.localizedDescription
                    let alert = UIAlertController(
                        title: NSLocalizedString("Create account failed", comment: "Create account failed"),
                        message: message,
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    
                    let cancelAction = UIAlertAction(title :"Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true , completion: nil)
                    return
                    
                }
            }
        )
    }
    
    
}

