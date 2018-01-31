//
//  MultipleLayerArcMenu.swift
//  MultipleLayerArcMenu
//
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation


import Foundation
import UIKit

let BUTTON_SIZE = 40
let SPACING = 5
let ANIMATION_DURATION = 0.5
let DISTANCE_BETWEEN_EACH_CIRCLE = 60



class MultipleLayerArcMenu : UIViewController {
    var _arrayOfMenuButtons : [[UIButton]] = []
    var _arrofMenuButtonImageDetails : [[[String : String]]] = [[[:]]]
    var _gestureRecognizerTap : UIGestureRecognizer?
    var selectedVC : UIViewController?
    var middleButtonFrame : CGRect?
    var totalCircleAngle : Int?
    var marginAngle : Int?
    var distanceBtwCircle : Int?
    weak var _delegateSemiCircularMenu: SemiCircularMenuDelegate? = nil
    var INITIALPOINT = CGPoint(x : Int(UIScreen.main.bounds.width), y : Int(UIScreen.main.bounds.height))
    
    init(listOfButtonDetails arrayOfButtonDetails : [[[String : String]]], viewController : UIViewController, centerButtonFrame : CGRect, circularButton : UIButton,startAngle : Int, totalAngle : Int, radius : Int)
    {
        
        super.init(nibName: nil, bundle: nil)
        selectedVC = viewController
        totalCircleAngle = totalAngle
        marginAngle = startAngle
        distanceBtwCircle = radius
        middleButtonFrame = centerButtonFrame
        _arrofMenuButtonImageDetails = arrayOfButtonDetails
        INITIALPOINT = CGPoint(x : Int(UIScreen.main.bounds.width - ((self.middleButtonFrame?.size.width) ?? 70) + 10), y : Int(UIScreen.main.bounds.height  - ((self.middleButtonFrame?.size.height) ?? 70) + 10))
        self.setTapGesture()
        self.initializeButtons()
        self.view.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.removeViewWithAnimation()
    }
    
    // mark - Initialization methods
    func setTapGesture()
    {
        _gestureRecognizerTap = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap(_:)))
        _gestureRecognizerTap?.cancelsTouchesInView = false;
        _gestureRecognizerTap?.delegate = self
        self.view.addGestureRecognizer(_gestureRecognizerTap!)
    }
    
    func initializeButtons()
    {
        _arrayOfMenuButtons = []
        for index in 0 ..< _arrofMenuButtonImageDetails.count
        {
            var arrayOfButtons : [UIButton] = []
            for subIndex in 0 ..< _arrofMenuButtonImageDetails[index].count
            {
                let button = UIButton.init(type: .system)
                button.tag = index
                button.addTarget(self, action: #selector(hideMenuOptions(_:)), for: .touchUpInside)
                button.setTitle(_arrofMenuButtonImageDetails[index][subIndex][MENU_OPTION_TITLE_KEY] , for: .normal)
                button.tintColor = UIColor.white
                button.layer.cornerRadius = CGFloat(BUTTON_SIZE/2)
                button.backgroundColor = UIColor.init(red: 255/255.0, green: 112/255.0, blue: 92/255.0, alpha: 1.0)
                button.frame = CGRect(x: Int(UIScreen.main.bounds.width) - BUTTON_SIZE , y: Int(UIScreen.main.bounds.height ) - BUTTON_SIZE, width: BUTTON_SIZE, height: BUTTON_SIZE)
                arrayOfButtons.append(button)
            }
            _arrayOfMenuButtons.append(arrayOfButtons)
            
        }
    }
    
    
    
    //mark - Show menu
    
    func showMenuOption()
    {
        let windows = UIApplication.shared.windows[0]
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        self.view.frame = windows.screen.bounds
        selectedVC?.view.addSubview(self.view)
        showMenuOptionButtons()
    }
    
    func showMenuOptionButtons()
    {
        for index in 0 ..< _arrayOfMenuButtons.count
        {
            for subIndex in 0 ..< _arrayOfMenuButtons[index].count
            {
                let button = _arrayOfMenuButtons[index][subIndex]
                button.center = CGPoint(x: INITIALPOINT.x, y: INITIALPOINT.y)
                
                self.view.addSubview(button)
            }
        }
        
        self.view.layoutIfNeeded()
        
        //Animate
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.updateButtonPosition()
            self.view.layoutIfNeeded()
        }) { (exist) in
        }
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.updateButtonPosition()
            self.view.layoutIfNeeded()
        }
    }
    
    
    func updateButtonPosition()
    {
        let circleCenter = CGPoint(x: INITIALPOINT.x, y: INITIALPOINT.y)
        
        //1st circle initialization
        for index in 0 ..< _arrofMenuButtonImageDetails.count
        {
            let marginAngle = (self.marginAngle) ?? 100
            let totalAvailableDegrees = (totalCircleAngle) ?? 100
            var incrementAngle = 0
            
            
            var currentAngle = marginAngle - SPACING
            var circleRadius = (distanceBtwCircle) ?? -54
            circleRadius    =  ((distanceBtwCircle) ?? -54) - (DISTANCE_BETWEEN_EACH_CIRCLE * index);
            if _arrofMenuButtonImageDetails[index].count > 1
            {
                incrementAngle  = totalAvailableDegrees / (_arrofMenuButtonImageDetails[index].count - 1)
            }
            else
            {
                incrementAngle = 0
            }
            
            for subIndex in 0 ..< _arrofMenuButtonImageDetails[index].count
            {
                
                let buttonCenter = CGPoint(x: Double(circleCenter.x) + cos(Double(currentAngle) * Double.pi/180.0) * Double(circleRadius), y: Double(circleCenter.y) + sin(Double(currentAngle) * Double.pi/180.0) * Double(circleRadius))
                let button = _arrayOfMenuButtons[index][subIndex]
                button.center = buttonCenter
                currentAngle -= incrementAngle
            }
        }
        
    }
    
    // mark - Remove menu
    @IBAction func hideMenuOptions (_ sender : UIButton)
    {
        
        let button = sender
        _delegateSemiCircularMenu?.SemiCircularMenuClickedButtonAtIndex(buttonIndex: button.tag, buttonOutlet: sender)
        
        removeViewWithAnimation()
        
    }
    
    func removeViewWithAnimation()
    {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            for index in 0 ..< self._arrayOfMenuButtons.count
            {
                for subIndex in 0 ..< self._arrayOfMenuButtons[index].count
                {
                    let button = self._arrayOfMenuButtons[index][subIndex]
                    button.center = CGPoint(x: self.INITIALPOINT.x, y: self.INITIALPOINT.y)
                }
            }
        }) { (exist) in
            self.view.removeFromSuperview()
            self.willMove(toParentViewController: nil)
            self.removeFromParentViewController()
        }
    }
    
    //mark - Tap gesture handling
    
    @IBAction func handleSingleTap (_ sender : UITapGestureRecognizer)
    {
        self.removeViewWithAnimation()
    }
    
}

extension MultipleLayerArcMenu : UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isKind(of: UIButton.self))!
        {
            return false
        }
        return true
    }
    
}


protocol SemiCircularMenuDelegate : class
{
    func SemiCircularMenuClickedButtonAtIndex(buttonIndex : Int, buttonOutlet : UIButton)
}



