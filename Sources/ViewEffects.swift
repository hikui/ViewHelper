//
//  ViewEffects.swift
//  ViewHelper: Version 4.2.4
//  Created by Melvin Rivera on 7/2/14.
//  https://github.com/melvitax/ViewHelper
//

import UIKit
import QuartzCore



@IBDesignable public extension UIView {
    
    // MARK: Border
    
    /**
     The layer border color
     */
    var borderColor: UIColor {
        get {
            return layer.borderColor == nil ? UIColor.clear : UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /**
     The layer border width
     */
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    /**
     Sets layer border with a dash pattern
     
     - Parameter lineDashPattern: The dash pattern applied to the shape’s path when stroked.
     - Parameter borderWidth: The width of the border.
     - Parameter borderColor: The color of the border.
     - Parameter cornerRadius: The radius of each corner oval.
     - Returns: self
     */
    func borderWithDashPattern(_ lineDashPattern: [Int], borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat?) -> UIView {
        let strokeLayer = CAShapeLayer()
        strokeLayer.strokeColor = borderColor.cgColor
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = borderWidth
        strokeLayer.lineDashPattern = lineDashPattern as [NSNumber]?
        if cornerRadius != nil {
            strokeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius!).cgPath
        } else {
            strokeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        }
        
        strokeLayer.frame = bounds
        layer.addSublayer(strokeLayer)
        return self
    }
    
    
    // MARK: Rounded Corners
    
    /**
     The layer corner radius
     */
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /**
     Creates a circle by rounding the corners to half the size of the width, sets border color and width
     
     - Parameter borderColor: The border color.
     - Parameter borderWidth: The border width.
     - Returns: self
     */
    func roundCornersToCircle(borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0) -> UIView {
        cornerRadius = width()/2
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        return self
    }
    
    /**
     Rounding the corners, sets border color and width
     
     - Parameter cornerRadius: The radius of each corner oval.
     - Parameter borderColor: The border color.
     - Parameter borderWidth: The border width.
     - Returns: self
     */
    func roundCorners(_ cornerRadius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat?) -> UIView {
        self.cornerRadius = cornerRadius
        if borderWidth != nil {
            self.borderWidth = borderWidth!
        }
        if borderColor != nil {
            self.borderColor = borderColor!
        }
        return self
    }
    
    
    // MARK: Shadow
    
    /**
     The shadow color of the layer
     */
    var shadowColor: UIColor {
        get {
            return layer.shadowColor == nil ? UIColor.clear : UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    
    /**
     The offset (in points) of the layer’s shadow.
     */
    var shadowOffset:CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /**
     The shadow opacity of the layer
     */
    var shadowOpacity:Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /**
     The blur radius (in points) used to render the layer’s shadow.
     */
    var shadowRadius:CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /**
     Shortcut for applying shadow.
     
     - Parameter color: The shadow color.
     - Parameter offset: The offset (in points) of the layer’s shadow.
     - Parameter radius: The blur radius (in points) used to render the layer’s shadow.
     - Parameter opacity: The shadow opacity.
     - Parameter isMasked: Indicates if it should be masked.
     - Returns: self UIView
     */
    func shadow(_ color: UIColor = UIColor.black, offset: CGSize = CGSize(width: 0, height: 0), radius: CGFloat = 6, opacity: Float = 1, isMasked: Bool = false) -> UIView {
        shadowColor = color
        shadowOffset = offset
        shadowOpacity = opacity
        shadowRadius = radius
        if isMasked {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
            let path = CGMutablePath()
            path.addRect(bounds.insetBy(dx: -10, dy: -10))
            path.addPath(UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath)
            let maskLayer = CAShapeLayer()
            maskLayer.path = path
            maskLayer.fillRule = kCAFillRuleEvenOdd
            layer.mask = maskLayer
        }
        return self
    }
    
    // MARK: Gradient
    
    /**
     Sets a gradient color layer
     
     - Parameter colors: Array of colors to use in gradient.
     - Parameter isHorizontal: Indicates if gradient is horizontal instead of vertical.
     - Returns: self
     */
    func setGradient(_ colors: [UIColor], isHorizontal:Bool = false) -> UIView {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = isHorizontal ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0.5, y: 1)
        gradientLayer.startPoint = isHorizontal ? CGPoint(x: 0.5, y: 1) : CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = colors
        return self
    }
    
    /**
     Animates colors of a gradient layer
     
     - Parameter colors: Array of colors to use in gradient.
     - Parameter duration: Duration os animation
     - Returns: self
     */
    func animateGradientToColors(_ colors: [UIColor], duration: CFTimeInterval = 3) -> UIView {
        let gradientLayer = layer as! CAGradientLayer
        let fromColors = gradientLayer.colors
        gradientLayer.colors = colors
        let a = CABasicAnimation(keyPath: "colors")
        a.fromValue = fromColors
        a.toValue = colors
        a.duration = duration
        a.isRemovedOnCompletion = true
        a.fillMode = kCAFillModeForwards
        a.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        //a.delegate = self
        layer.add(a, forKey: "Gradient Animation")
        return self
    }
    
    /**
     Sets a gradient layer mask
     
     - Parameter alphas: Array of alpha values to use for gradient mask.
     - Parameter isHorizontal: Indicates if gradient is horizontal instead of vertical.
     - Returns: self
     */
    func setGradientMask(_ alphas:[CGFloat], isHorizontal:Bool = false) -> UIView {
        let gradientLayer = (layer.mask is CAGradientLayer) ? layer.mask as! CAGradientLayer : CAGradientLayer()
        var colors = [CGColor]()
        for alpha in alphas {
            colors.append(UIColor(white: 1, alpha: alpha).cgColor)
        }
        gradientLayer.startPoint = isHorizontal ? CGPoint(x: 1, y: 0.5) : CGPoint(x: 0.5, y: 1)
        gradientLayer.startPoint = isHorizontal ? CGPoint(x: 0, y: 0.5) : CGPoint(x: 0.5, y: 0)
        gradientLayer.colors = colors
        layer.mask = gradientLayer
        return self
    }
    
    
    
}
