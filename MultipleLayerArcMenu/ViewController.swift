//
//  ViewController.swift
//  MultipleLayerArcMenu
//

//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

let MENU_OPTION_TITLE_KEY = "titleLabel"
let MENU_OPTION_IMAGE_KEY = "imageName"

class ViewController: UIViewController {
    var _circularMenuVC : MultipleLayerArcMenu?
    var arrayOfMenuButtons = [[[String : String]]]()
    @IBOutlet weak var optionButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        arrayOfMenuButtons = [[[MENU_OPTION_TITLE_KEY : "A1"],[MENU_OPTION_TITLE_KEY : "B1"],[MENU_OPTION_TITLE_KEY : "C1"]],[[MENU_OPTION_TITLE_KEY : "A2"],[MENU_OPTION_TITLE_KEY : "B2"],[MENU_OPTION_TITLE_KEY : "C2"],[MENU_OPTION_TITLE_KEY : "D2"]],[[MENU_OPTION_TITLE_KEY : "A3"],[MENU_OPTION_TITLE_KEY : "B3"],[MENU_OPTION_TITLE_KEY : "C3"],[MENU_OPTION_TITLE_KEY : "D3"],[MENU_OPTION_TITLE_KEY : "D3"]]]
        optionButton.layer.cornerRadius = optionButton.frame.size.width/2
        optionButton.backgroundColor = UIColor.init(red: 255/255.0, green: 112/255.0, blue: 92/255.0, alpha: 1.0)
        optionButton.tintColor = UIColor.white
        optionButton.setTitle("Menu", for: .normal)
        optionButton.setTitleColor(UIColor.white , for: .normal)
        self.view.bringSubview(toFront: optionButton)
        
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        self._circularMenuVC = MultipleLayerArcMenu.init(listOfButtonDetails: arrayOfMenuButtons, viewController: self, centerButtonFrame: self.optionButton.frame, circularButton: self.optionButton, startAngle: 95, totalAngle: 95, radius: -80)
        
        self._circularMenuVC?._delegateSemiCircularMenu = self
        self._circularMenuVC?.showMenuOption()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension ViewController : SemiCircularMenuDelegate
{
    func SemiCircularMenuClickedButtonAtIndex(buttonIndex: Int, buttonOutlet: UIButton)
    {
        print("title text in button = \(buttonOutlet.titleLabel?.text ?? "") is tapped")
    }
}

