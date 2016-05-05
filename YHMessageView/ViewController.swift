//
//  ViewController.swift
//  YHMessageView
//
//  Created by harvey on 16/5/5.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var lastContentOffset:CGFloat?
    var keyboardHeight:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(followButton)
        self.view.addSubview(messageView)
        self.view.sendSubviewToBack(messageView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear), name:UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notiOfTextViewContentSizeHeightChangedActionHeigher), name:NotiOfTextViewContentSizeHeightChangedHeigher, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notiOfTextViewContentSizeHeightChangedActionLower), name:NotiOfTextViewContentSizeHeightChangedLower, object: nil)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    private lazy var followButton:UIButton = {
        
        let followButton = UIButton(frame:CGRectMake(self.view.bounds.width-150,15,100,30))
        followButton.backgroundColor = UIColor.redColor()
        followButton.addTarget(self, action:#selector(sendComment), forControlEvents: UIControlEvents.TouchUpInside)
        return followButton
    }()

    // 评论窗口
    private lazy var messageView:YHMessageView = {
        
        let messageView:YHMessageView = YHMessageView(frame:CGRectMake(0,self.view.bounds.height - CGFloat(MessageViewDefaultHeight)+40,self.view.bounds.width, CGFloat(MessageViewDefaultHeight)))
        messageView.delegate = self
        return messageView
    }()
    
    func keyboardWillAppear(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                keyboardHeight = keyboardSize.size.height
                let messageViewNewY = self.view.bounds.height - (keyboardHeight!+40)
                
                UIView.animateWithDuration(0.333) {
                    self.messageView.frame = CGRectMake(self.messageView.frame.origin.x, messageViewNewY, self.messageView.frame.size.width, self.messageView.frame.size.height)
                }
                
                
            }}
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
       
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                keyboardHeight = keyboardSize.height
            }}
        
    }
    
    
    func notiOfTextViewContentSizeHeightChangedActionHeigher(notification: NSNotification){
        
        let height = notification.object as! CGFloat
        messageView.frame = CGRectMake(self.messageView.frame.origin.x,self.messageView.frame.origin.y - height, self.messageView.frame.size.width, self.messageView.frame.size.height + height)
        self.messageView.textView!.frame = CGRectMake(CGFloat(TextViewLeadingMargin),5, self.messageView.bounds.size.width - CGFloat(TextViewLeadingMargin+TextViewTrailingMargin+SendBtnWidth+SendBtnTrailingMargin), self.messageView.bounds.size.height-10);
        
    }
    
    func notiOfTextViewContentSizeHeightChangedActionLower(notification: NSNotification){
        
        
        let height = notification.object as! CGFloat
        self.messageView.frame = CGRectMake(self.messageView.frame.origin.x, self.messageView.frame.origin.y + height, self.messageView.frame.size.width, self.messageView.frame.size.height - height);
        self.messageView.textView!.frame = CGRectMake(CGFloat(TextViewLeadingMargin),5, self.messageView.bounds.size.width - CGFloat(TextViewLeadingMargin+TextViewTrailingMargin+SendBtnWidth+SendBtnTrailingMargin), self.messageView.bounds.size.height-10);
    }


}
extension ViewController:YHMessageViewDelegate{
    
    func sendComment(comment:NSString){
       
        messageView.textView?.becomeFirstResponder()
    
    }
    
    func asSendBtnAction(sender: UIButton) {
       
        
    }
    
    func asTextViewDidBeginEditing(textView: UITextView) {
        
        
    }
    
    func asTextViewDidEndEditing(textView: UITextView) {
        
        let messageViewNewY = self.messageView.frame.origin.y + keyboardHeight!
        UIView.animateWithDuration(0.333) {
            self.messageView.frame = CGRectMake(self.messageView.frame.origin.x, messageViewNewY, self.messageView.frame.size.width, self.messageView.frame.size.height);
        }
        self.view.sendSubviewToBack(messageView)
        keyboardHeight = 0
    }
}

