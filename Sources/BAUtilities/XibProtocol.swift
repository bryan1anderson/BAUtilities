//
//  XibProtocol.swift
//  Canvass
//
//  Created by Bryan on 11/15/16.
//  Copyright © 2016 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import UIKit

open class XibView: UIView, XibViewProtocol {
    public var view: UIView!
    
    public var nibName: String { return String(describing: type(of: self)) }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
}

public protocol XibViewProtocol: class {
    var view: UIView! { get set }
    var nibName: String { get }
}

public extension XibViewProtocol where Self: UIView {
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let name = nibName//String(describing: type(of: self)) //self.description//String(describing: self)
        let nib = UINib(nibName: name, bundle: bundle)
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
