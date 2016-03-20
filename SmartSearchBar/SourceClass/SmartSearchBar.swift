//
//  SmartSearchBar.swift
//  cicada
//
//  Created by john on 2/4/16.
//  Copyright © 2016 Cozitrip IP Pty Ltd. All rights reserved.
//

import UIKit

enum SmartBarStatus {
    case Normal
    case Circle
    case Top
}

protocol SmartSearchBarDelegate : class{
    func startEditing()
    func finishEditing()
}

class SmartSearchBar: UIView {
    
    weak var smartSearchBarDelegate : SmartSearchBarDelegate?

    var status : SmartBarStatus = .Normal
    var oldStatus : SmartBarStatus = .Normal
    
    @IBOutlet weak var searchBarLeftOffset: NSLayoutConstraint!
    @IBOutlet weak var searchBarTopOffset: NSLayoutConstraint!
    @IBOutlet weak var searchBarRightOffset: NSLayoutConstraint!
    
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var clickButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    
    weak var scrollView : UIScrollView?

    var destinationListView : DestinationListView?

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp()
    {
        self.layer.cornerRadius = 4.0
    }
    
    func setDestinationName(name : String?)
    {
        textField.text = name
    }
    
    @IBAction func clickView()
    {
        if self.status == .Top
        {
            return
        }
        
        clickButton.hidden = true
        changeToStatus(.Top, screenWidth: self.superview!.bounds.width ,scrollView:  scrollView)
    }
    
    @IBAction func cancelButtonClick()
    {
        changeToStatus(.Normal, screenWidth: self.superview!.bounds.width,scrollView:  scrollView)
    }

    func SuperWantchangeToStatus(status : SmartBarStatus,screenWidth : CGFloat)
    {
        if self.status == .Top && (status == .Normal || status == .Circle)
        {
            return
        }
        
        changeToStatus(status ,screenWidth: screenWidth ,scrollView:  scrollView)
    }
    
    func changeToStatus(status : SmartBarStatus,screenWidth : CGFloat ,scrollView : UIScrollView?)
    {
        self.scrollView = scrollView
        if self.status == status
        {
            return
        }
        
        
        if status == .Normal
        {
            self.status = .Normal
            self.cancelButton.hidden = true
            destinationListView?.hidden = true
            self.textField.text = nil
            self.textField.resignFirstResponder()
            closeListView()
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.layer.cornerRadius = 4.0
                self.searchBarRightOffset.constant = 20
                self.textField.alpha = 1.0
                self.searchBarTopOffset.constant = 20
                self.searchBarLeftOffset.constant = 20
                self.layoutIfNeeded()
                }, completion: { (result) -> Void in
                    self.clickButton.hidden = false
                    
            })

        }
        else if status == .Circle
        {
            self.status = .Circle
            UIView.animateWithDuration(0.2) { () -> Void in
                self.layer.cornerRadius = self.bounds.height / 2.0
                self.searchBarRightOffset.constant = screenWidth - self.searchBarLeftOffset.constant - self.bounds.height
                self.textField.alpha = 0.0
                self.layoutIfNeeded()
            }
            
        }
        else if status == .Top
        {
            if let offset = self.scrollView?.contentOffset
            {
                self.scrollView?.setContentOffset(offset, animated: false)
            }
            
            
            self.oldStatus = self.status
            self.status = .Top
            self.cancelButton.alpha = 0
            self.cancelButton.hidden = false
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.layer.cornerRadius = 0
                self.searchBarRightOffset.constant = 0
                self.searchBarLeftOffset.constant = 0
                self.searchBarTopOffset.constant = 0
                self.textField.alpha = 1.0
                self.layoutIfNeeded()
                }, completion: { (result) -> Void in
                    UIView.animateWithDuration(0.2) { () -> Void in
                        self.cancelButton.alpha = 1.0
                        self.textField.becomeFirstResponder()
                    }
            })
            
        }
    }
    

}


extension SmartSearchBar : UITextFieldDelegate
{
    
    private func displayDestinationText(text : String?) {
        textField.text = text
    }
    
    func scrollList() {
        if textField.canResignFirstResponder()
        {
            textField.resignFirstResponder()
        }
    }
    
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        smartSearchBarDelegate?.startEditing()
        textField.returnKeyType = .Search
        return true
    }
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        if textField == self.textField
        {
            destinationListView?.searchByGoogle(textField.text)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.textField
        {
            
            if destinationListView == nil
            {
                destinationListView = DestinationListView(frame: CGRectMake(0 , 64 , self.superview!.bounds.width , self.superview!.bounds.size.height-44))
                self.superview!.addSubview(destinationListView!)
            }
            destinationListView?.hidden = false
            
        }
        
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textField End")
        
        return true
    }
    
    func closeListView()
    {
        if destinationListView != nil
        {
            destinationListView?.removeFromSuperview()
            destinationListView = nil
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        if textField == self.textField
//        {
//            destinationListView?.reloadTableView(textField.text!)
//        }
        
        textField.resignFirstResponder()
        return true
    }
}



