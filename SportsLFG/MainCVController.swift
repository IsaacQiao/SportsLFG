//
// File   : MainCVController.swift
// Author : Charles Li
// Date created: Oct.11 2015
// Date edited : Nov.22 2015
// Description: This is responsible for the main tab bar view controller(custom control) and 
//loads different view depending on the selected button


import UIKit

class MainCVController : UIViewController
{
  
  //MARK: Properties
  
 var currentViewController: UIViewController!
  
  @IBOutlet weak var CV: UIView!
  @IBOutlet var TabBarButtons: [UIButton]!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //NSLog("check1")
    if(TabBarButtons.count > 0) {
      performSegueWithIdentifier("Home", sender: TabBarButtons[0])
    }
  }
  
  
  //This method prepare the segue and change the sender button's state to selected
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    let availableIdentifiers = ["Home","LFG"]
    
    if(availableIdentifiers.contains(segue.identifier!)) {
    
    for btn in TabBarButtons {
    btn.selected = false
    }
    
    let senderBtn = sender as! UIButton
    senderBtn.selected = true
    
    }
    
    //This sets the parent variable to the current view controller 
    /*
    if(segue.identifier == "Home")
    {
    let HVController = segue.destinationViewController as! HomeViewController
    HVController.parent = self
    
    } 
    */

    
    
  }
  
  deinit{
    
    print("MainCVControlller is released")
    self.TabBarButtons.removeAll()
  }
  
}  

