//
//  UIKitpublic extensions.swift
//  Training
//
//  Created by Bryan on 9/20/16.
//  Copyright © 2016 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import UIKit
import Nuke
import CoreMedia
import Closures

public extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            @unknown default:
                fatalError()
            }
        }
    }
}

public extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    public func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                    withAttributes: attributes)
        }
    }
    
}

public extension UIView {
    
    func constrainCentered(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        let horizontalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let heightContraint = NSLayoutConstraint(
            item: subview,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.height)
        
        let widthContraint = NSLayoutConstraint(
            item: subview,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.width)
        
        addConstraints([
            horizontalContraint,
            verticalContraint,
            heightContraint,
            widthContraint])
        
    }
    
    func constrainToEdges(_ subview: UIView, insets: UIEdgeInsets = .zero) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: insets.top)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: insets.bottom)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: insets.left)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: insets.right)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
}


public extension CALayer {
    func addShadow(name: String) {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.2
        self.shadowRadius = 10
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners(name: name)
        }
    }
    func roundCorners(radius: CGFloat, name: String) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners(name: name)
        }
    }
    
    private func addShadowWithRoundedCorners(name: String) {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius, name: name) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == name {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = name
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }

}

public extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}

public struct ImageWrapper: Codable {
    public let image: Image
    
    public enum CodingKeys: String, CodingKey {
        case image
    }
    
    // Image is a standard UI/NSImage conditional typealias
    public init(image: Image) {
        self.image = image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: CodingKeys.image)
        guard let image = Image(data: data) else {
            throw DataError.failedInit("Image Wrapper decoding failed")
        }
        
        self.image = image
    }
    
    // cache_toData() wraps UIImagePNG/JPEGRepresentation around some conditional logic with some whipped cream and sprinkles.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = image.pngData() ?? image.jpegData(compressionQuality: 1) else {
            throw DataError.failedInit("Image Wrapper encoding failed")
        }
        
        try container.encode(data, forKey: CodingKeys.image)
    }
}

public extension UIStackView {
    var subStackViews: [UIStackView] {
        let arrangedSubs = self.arrangedSubviews
        let stacks = arrangedSubs.recursiveFlatMap(root: self, transform: { $0 as? UIStackView }, children: {(($0 as? UIStackView)?.arrangedSubviews) ?? [] })
        return stacks
    }
    
}

public final class ImageFilterDrawInCircle: NSObject, ImageProcessing {
    public var identifier: String = "ImageFilterDrawInCircle"
    
    public func process(image: Image, context: ImageProcessingContext?) -> Image? {
        return drawImageInCircle(image: cropImageToSquare(image: image))
    }
    
}

public func drawImageInCircle(image: UIImage?) -> UIImage? {
    guard let image = image else {
        return nil
    }
    UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
    let radius = min(image.size.width, image.size.height) / 2.0
    let rect = CGRect(origin: CGPoint.zero, size: image.size)
    UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
    image.draw(in: rect)
    let processedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return processedImage
}

public func cropImageToSquare(image: UIImage?) -> UIImage? {
    guard let image = image else {
        return nil
    }
    func cropRectForSize(size: CGSize) -> CGRect {
        let side = min(floor(size.width), floor(size.height))
        let origin = CGPoint(x: floor((size.width - side) / 2.0), y: floor((size.height - side) / 2.0))
        return CGRect(origin: origin, size: CGSize(width: side, height: side))
    }
    let bitmapSize = CGSize(width: image.cgImage!.width, height: image.cgImage!.height)
    guard let croppedImageRef = image.cgImage!.cropping(to: cropRectForSize(size: bitmapSize)) else {
        return nil
    }
    return UIImage(cgImage: croppedImageRef, scale: image.scale, orientation: image.imageOrientation)
}

extension UIAlertAction {
    public static let cancel = UIAlertAction(title: "Cancel", style: .cancel)
}


public extension UIView {

    class func animate(withDuration duration: TimeInterval, delay: Double = 0, dampingRatio: CGFloat, options: UIView.AnimationOptions, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
         UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: 1, options: options, animations: animations, completion: completion)
    }
}

class Generator: UIFeedbackGenerator {
    
}


public extension UIRectCorner {
    public static var topCorners: UIRectCorner {
        
        return [.topLeft, .topRight]
    }
}

public extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}



//extension CGPath {
//    
//    func forEach( body: @convention(block) (CGPathElement) -> Void) {
//        typealias Body = @convention(block) (CGPathElement) -> Void
//        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
//            let body = unsafeBitCast(info, to: Body.self)
//            body(element.pointee)
//        }
////        print(MemoryLayout.size(ofValue: body))
//        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
//        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
//    }
//    
//    
//    func getPathElementsPoints() -> [CGPoint] {
//        var arrayPoints : [CGPoint]! = [CGPoint]()
//        self.forEach { element in
//            switch (element.type) {
//            case CGPathElementType.moveToPoint:
//                arrayPoints.append(element.points[0])
//            case .addLineToPoint:
//                arrayPoints.append(element.points[0])
//            case .addQuadCurveToPoint:
//                arrayPoints.append(element.points[0])
//                arrayPoints.append(element.points[1])
//            case .addCurveToPoint:
//                arrayPoints.append(element.points[0])
//                arrayPoints.append(element.points[1])
//                arrayPoints.append(element.points[2])
//            default: break
//            }
//        }
//        return arrayPoints
//    }
//    
//    func getPathElementsPointsAndTypes() -> ([CGPoint],[CGPathElementType]) {
//        var arrayPoints : [CGPoint]! = [CGPoint]()
//        var arrayTypes : [CGPathElementType]! = [CGPathElementType]()
//        self.forEach { element in
//            switch (element.type) {
//            case CGPathElementType.moveToPoint:
//                arrayPoints.append(element.points[0])
//                arrayTypes.append(element.type)
//            case .addLineToPoint:
//                arrayPoints.append(element.points[0])
//                arrayTypes.append(element.type)
//            case .addQuadCurveToPoint:
//                arrayPoints.append(element.points[0])
//                arrayPoints.append(element.points[1])
//                arrayTypes.append(element.type)
//                arrayTypes.append(element.type)
//            case .addCurveToPoint:
//                arrayPoints.append(element.points[0])
//                arrayPoints.append(element.points[1])
//                arrayPoints.append(element.points[2])
//                arrayTypes.append(element.type)
//                arrayTypes.append(element.type)
//                arrayTypes.append(element.type)
//            default: break
//            }
//        }
//        return (arrayPoints,arrayTypes)
//    }
//}

public extension UIView {
    func transform(from: CGRect, to: CGRect) -> CGAffineTransform {
        let transform = CGAffineTransform(translationX: to.midX-from.midX, y: to.midY-from.midY)
        return transform.scaledBy(x: to.width/from.width, y: to.height/from.height)
    }
    
    func transform( to: CGRect, scaledBy: (x: CGFloat, y: CGFloat)? = nil) -> CGAffineTransform {
        let transform = CGAffineTransform(translationX: to.midX-frame.midX, y: to.midY-frame.midY)
        if let scaledBy = scaledBy {
            return transform.scaledBy(x: scaledBy.x, y: scaledBy.y)
        }
        return transform.scaledBy(x: to.width/frame.width, y: to.height/frame.height)
    }
}

public extension UIView {
    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)//CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.layer.add(animation, forKey: "cornerRadius")
        self.layer.cornerRadius = to
    }
}

public extension UITableView {
        
    func register(nibClass: UITableViewCell.Type) {
        let name = String(describing: nibClass)
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }

    
}

public extension UICollectionView {
    
    func register(nibClass: UICollectionViewCell.Type) {
        let name = String(describing: nibClass)
        register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}

public protocol CellResuseable {
    static var identifier: String { get }
}

extension UITableViewCell: CellResuseable {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: CellResuseable {
    public static var identifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    func dequeueReseuableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: CellResuseable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Couldn't instantiate cell with identifier \(T.identifier) ")
        }
        
        return cell
    }
}

public extension UITableView {
    func dequeueReseuableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: CellResuseable {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Couldn't instantiate cell with identifier \(T.identifier) ")
        }
        return cell
    }
}

public extension UIScrollView {
    var currentPage: Int {
        return Int(round(contentOffset.x / bounds.size.width))
    }
    func scrollToPage(_ index: Int, animated: Bool = true) {
        var newFrame = frame
        newFrame.origin.x = frame.size.width * CGFloat(index)
        
        // frame.origin.y = 0
//        
//        UIView.animate(withDuration: 0.1, delay: 0, options: [UIView.AnimationOptions.curveEaseIn, .allowUserInteraction], animations: {
//            //            self.alpha = 0.8
//        }) { (completed) in
//            UIView.animate(withDuration: 0.2, animations: {
//                //                    self.alpha = 1
//            })
//        }
        if animated {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseIn, .allowUserInteraction], animations: { () -> Void in
                //            self.scrollRectToVisible(newFrame, animated: false)
                //            self.setContentOffset(newFrame.origin, animated: false)
                self.contentOffset.x = newFrame.origin.x
            }) { (completed) -> Void in
                self.delegate?.scrollViewDidEndScrollingAnimation?(self)
            }
        } else {
            self.contentOffset.x = newFrame.origin.x
            
        }
        
        

    }
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

public extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
    
    func scrollToViewX(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: childStartPoint.x / 2, y: 0, width: 1, height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}

fileprivate let minimumHitArea = CGSize(width: 60, height: 60)
public extension UIButton {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil

    }
}

public extension UIButton {
    
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
}

public extension UISlider {
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let bounds = self.bounds.insetBy(dx: -minimumHitArea.width, dy: -minimumHitArea.height);
        return bounds.contains(point)
    }
    
}


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




