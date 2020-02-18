//
//  KeyboardLayoutProtocol.swift
//  EmberUI
//
//  Created by Bryan on 8/29/19.
//  Copyright © 2019 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol KeyboardLayoutProtocol {
    @objc optional func updateBottomLayoutConstraint(with notification: Notification)
    weak var keyboardViewHeight: NSLayoutConstraint! { get set }
    func updateKeyboardConstraint(notification: Notification)
}

extension KeyboardLayoutProtocol where Self: UIViewController {
    
    public func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateKeyboardConstraint(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateKeyboardConstraint(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func updateBottomLayoutConstraint(with notification: Notification, completion: ((_ completed: Bool) -> ())? = nil) {
        
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(rawAnimationCurve))
        
        //        let userInfo:NSDictionary = notification.userInfo!
        //        let keyboardFrame:NSValue = userInfo.valueForKey(UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        //        let keyboardRectangle = keyboardFrame.CGRectValue()
        //        let keyboardHeight = keyboardRectangle.height
        
        keyboardViewHeight.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIView.AnimationOptions.beginFromCurrentState, animationCurve], animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            completion?(value)
        })
    }
}

