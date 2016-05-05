//
//  YHMessageView.swift
//  Microduino
//
//  Created by harvey on 16/4/25.
//  Copyright © 2016年 harvey. All rights reserved.
//

import UIKit
protocol YHMessageViewDelegate {

    func asTextViewDidBeginEditing(textView:UITextView)
    func asTextViewDidEndEditing(textView:UITextView)
    func asSendBtnAction(sender:UIButton)

}
let  NotiOfTextViewContentSizeHeightChangedHeigher = "notiOfTextViewContentSizeHeightChangedHeigher"
let  NotiOfTextViewContentSizeHeightChangedLower = "notiOfTextViewContentSizeHeightChangedLower"

let MessageViewDefaultHeight:CGFloat = 40
let MessageViewLeadingMargin:CGFloat = 10
let MessageViewTrailingMargin:CGFloat = 10

let TextViewLeadingMargin:CGFloat = 5
let TextViewTrailingMargin:CGFloat = 10

let SendBtnLeadingMargin =  TextViewTrailingMargin
let SendBtnTrailingMargin:CGFloat =  5
let SendBtnWidth:CGFloat = 50
let SendBtnHeight:CGFloat = 25
class YHMessageView: UIView,UITextViewDelegate {

    var textViewOriginContentSizeHieght:CGFloat = 0.0   //初始textview 的 contentSize
    var textViewCurrentContentSizeHieght:CGFloat = 0.0 //当前textview 的 contentSize
    var delegate : YHMessageViewDelegate?
    var textView:UITextView?
    var sendBtn:UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setUpViews()
        registerNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
    
        self.backgroundColor = UIColor(red:0.96 ,green:0.96,blue: 0.96,alpha:1.00)
        textView = UITextView()
        self.addSubview(textView!)
        self.textView!.frame = CGRectMake(TextViewLeadingMargin,5,self.bounds.width - TextViewLeadingMargin - TextViewTrailingMargin - SendBtnWidth - SendBtnTrailingMargin, self.bounds.size.height-10)
        self.textView!.delegate = self
        textViewOriginContentSizeHieght = (self.textView!.frame.size.height)
        textViewCurrentContentSizeHieght = textViewOriginContentSizeHieght
        sendBtn = UIButton()
        self.addSubview(sendBtn!)
        sendBtn!.frame = CGRectMake(self.frame.size.width - SendBtnTrailingMargin - SendBtnWidth, CGFloat((self.frame.size.height-SendBtnHeight)/2), SendBtnWidth, SendBtnHeight)
        sendBtn!.setTitle("发送", forState: UIControlState.Normal)
        sendBtn!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sendBtn!.backgroundColor = UIColor(red:0.32,green:0.81,blue: 0.08,alpha: 1.00)
        sendBtn!.layer.masksToBounds = true
        sendBtn!.layer.cornerRadius = 3
        sendBtn!.addTarget(self, action:#selector(sendBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        
    
    
    }
    
    func sendBtnAction(sender:UIButton){
    
        delegate?.asSendBtnAction(sender)
        
    }
 
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillShowNotification, object:nil)

        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
     
        delegate?.asTextViewDidBeginEditing(textView)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
     
        delegate?.asTextViewDidEndEditing(textView)
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let textViewContentSizeHeight = textView.contentSize.height as CGFloat   //实时获取conentSize height
        if (textViewContentSizeHeight > textViewCurrentContentSizeHieght) {

        let noti = NSNotification(name:NotiOfTextViewContentSizeHeightChangedHeigher,object: NSNumber(float:Float(textViewContentSizeHeight - textViewCurrentContentSizeHieght)))
        NSNotificationCenter.defaultCenter().postNotification(noti)
   
        }
        if (textViewContentSizeHeight < textViewCurrentContentSizeHieght && textViewContentSizeHeight > textViewOriginContentSizeHieght) {
             let noti = NSNotification(name:NotiOfTextViewContentSizeHeightChangedLower,object: NSNumber(float:Float(textViewCurrentContentSizeHieght - textViewContentSizeHeight)))
            NSNotificationCenter.defaultCenter().postNotification(noti)

        }
    }
    func notiOfTextViewContentSizeHeightChangedHeiger(noti:NSNotification){
    
        textViewCurrentContentSizeHieght += (noti.object as! CGFloat)
        sendBtn!.frame =  CGRectMake(self.sendBtn!.frame.origin.x, self.sendBtn!.frame.origin.y + (noti.object as! CGFloat), self.sendBtn!.frame.size.width, self.sendBtn!.frame.size.height)

    
    }
 
    func notiOfTextViewContentSizeHeightChangedLower(noti:NSNotification){
    
        textViewCurrentContentSizeHieght -= (noti.object as! CGFloat)
        sendBtn!.frame = CGRectMake(self.sendBtn!.frame.origin.x, self.sendBtn!.frame.origin.y - (noti.object as! CGFloat), self.sendBtn!.frame.size.width, self.sendBtn!.frame.size.height);
        
    
    }

    func registerNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(notiOfTextViewContentSizeHeightChangedHeiger), name:NotiOfTextViewContentSizeHeightChangedHeigher, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(notiOfTextViewContentSizeHeightChangedLower), name: NotiOfTextViewContentSizeHeightChangedLower, object: nil)
        
    
    }
  
}
