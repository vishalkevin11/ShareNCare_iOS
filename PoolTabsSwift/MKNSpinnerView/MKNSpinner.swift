//
//  MKNSpinner.swift //costomized Spinner
//  MKSpinner
//
//  Created by Moayad on 10/10/15.
//  Copyright © 2015 Moayad. All rights reserved.
//

import UIKit



open class MKNSpinner: UIView {
    
    enum SpinnerStyle : Int{
        case none = 0
        case light = 1
        case dark = 2
    }
    
    var Style : SpinnerStyle = .none
    
    open var hidesWhenStopped : Bool = false
    
    open var outerFillColor : UIColor = UIColor.clear
    open var outerStrokeColor : UIColor = UIColor.gray
    open var outerLineWidth : CGFloat = 5.0
    open var outerEndStroke : CGFloat = 0.5
    open var outerAnimationDuration : CGFloat = 2.0
    
    open var enableInnerLayer : Bool = true
    
    open var innerFillColor : UIColor  = UIColor.clear
    open var innerStrokeColor : UIColor = UIColor.gray
    open var innerLineWidth : CGFloat = 5.0
    open var innerEndStroke : CGFloat = 0.5
    open var innerAnimationDuration : CGFloat = 1.6
    
    open var labelText : String  = ""
    open var labelFont : String  = "Helvetica"
    open var labelTextColor : UIColor  = UIColor.black
    
    open var labelFontSize : CGFloat = 15.0
    
    var currentInnerRotation : CGFloat = 0
    var currentOuterRotation : CGFloat = 0
    
    var innerView : UIView = UIView()
    var outerView : UIView = UIView()
    
    var label: UILabel!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.commonInit()
    }
    
    func commonInit(){
        self.Style = MKNSpinner.SpinnerStyle.light
        let background = UIView(frame: self.frame)
        background.alpha = 0.75
        background.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
        background.layer.cornerRadius = 10
        background.clipsToBounds = true
        
        addSubview(background)
        
        
        
        
        
//        self.backgroundColor = UIColor(red: 253.0/255.0, green: 253.0/255.0, blue: 253.0/255.0, alpha: 0.9)
        
        switch Style{
        case .dark:
            outerStrokeColor = UIColor.gray
            innerStrokeColor = UIColor.gray
            labelTextColor = UIColor.gray
        case .light:
            outerStrokeColor = UIColor ( red: 0.9333, green: 0.9333, blue: 0.9333, alpha: 1.0 )
            innerStrokeColor = UIColor ( red: 0.9333, green: 0.9333, blue: 0.9333, alpha: 1.0 )
            labelTextColor = UIColor ( red: 0.9333, green: 0.9333, blue: 0.9333, alpha: 1.0 )
        case .none:
            break
        }
        
        
        self.addSubview(outerView)
        outerView.frame = CGRect(x: 10 , y: 10, width: self.frame.size.width-20, height: self.frame.size.height-20)
        outerView.center = self.center//self.convertPoint(self.center, fromCoordinateSpace: self.superview!)
        
        let outerLayer = CAShapeLayer()
        outerLayer.path = UIBezierPath(ovalIn: outerView.bounds).cgPath
        outerLayer.lineWidth = outerLineWidth
        outerLayer.strokeStart = 0.0
        outerLayer.strokeEnd = outerEndStroke
        outerLayer.lineCap = kCALineCapRound
        outerLayer.fillColor = outerFillColor.cgColor
        outerLayer.strokeColor = outerStrokeColor.cgColor
        outerView.layer.addSublayer(outerLayer)
        
        if enableInnerLayer{
            
            self.addSubview(innerView)
            innerView.frame = CGRect(x: 0 , y: 0, width: self.frame.size.width - 40, height: self.frame.size.height - 40)
            innerView.center =  self.center//self.convertPoint(self.center, fromCoordinateSpace: self.superview!)
            let innerLayer = CAShapeLayer()
            innerLayer.path = UIBezierPath(ovalIn: innerView.bounds).cgPath
            innerLayer.lineWidth = innerLineWidth
            innerLayer.strokeStart = 0
            innerLayer.strokeEnd = innerEndStroke
            innerLayer.lineCap = kCALineCapRound
            innerLayer.fillColor = innerFillColor.cgColor
            innerLayer.strokeColor = innerStrokeColor.cgColor
            
            innerView.layer.addSublayer(innerLayer)
        }
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
        
        label.text = labelText
        label.textColor = labelTextColor
        label.font = UIFont(name: labelFont, size: labelFontSize)
        
        self.addSubview(label)
        /*if enableInnerLayer{
         label.frame.size.width = innerView.frame.size.width/1.20
         label.frame.size.height = innerView.frame.size.height
         }
         else{
         label.frame.size.width = outerView.frame.size.width/1.2
         label.frame.size.height = outerView.frame.size.height
         }*/
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.center = self.center//self.convertPoint(self.center, fromCoordinateSpace: self.superview!)
        
        self.startAnimating()
    }
    
    
    func animateInnerRing(){
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0 * CGFloat(M_PI/180)
        rotationAnimation.toValue = 360 * CGFloat(M_PI/180)
        rotationAnimation.duration = Double(innerAnimationDuration)
        rotationAnimation.repeatCount = HUGE
        self.innerView.layer.add(rotationAnimation, forKey: "rotateInner")
    }
    func animateOuterRing(){
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 360 * CGFloat(M_PI/180)
        rotationAnimation.toValue = 0 * CGFloat(M_PI/180)
        rotationAnimation.duration = Double(outerAnimationDuration)
        rotationAnimation.repeatCount = HUGE
        self.outerView.layer.add(rotationAnimation, forKey: "rotateOuter")
    }
    
    func startAnimating(){
        
        self.isHidden = false
        
        self.animateOuterRing()
        self.animateInnerRing()
    }
    
    func stopAnimating(){
        if hidesWhenStopped{
            self.isHidden = true
        }
        self.outerView.layer.removeAllAnimations()
        self.innerView.layer.removeAllAnimations()
        
    }
    
    var isShown:Bool = false
    
    func updateFrame() {
        let window:UIWindow = UIApplication.shared.windows.first!
        MKNSpinner.sharedInstance.center = window.center
    }
    
    open class var sharedInstance: MKNSpinner {
        struct Singleton {
            static let instance = MKNSpinner(frame: CGRect(x: 0,y: 0,width: 140,height: 140))
        }
        return Singleton.instance
    }
    
    open  func show(_ title: String, animated: Bool = true) -> MKNSpinner {
        
        let window:UIWindow = UIApplication.shared.windows.first!
        let spinner = MKNSpinner.sharedInstance
        
        spinner.Style = MKNSpinner.SpinnerStyle.light
        spinner.label.text = title
        spinner.updateFrame()
        spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        spinner.isUserInteractionEnabled = false
        if spinner.superview == nil {
            //show the spinner
            spinner.alpha = 0.0
            window.addSubview(spinner)
            
            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
                spinner.alpha = 1.0
                }, completion: nil)
            
            // Orientation change observer
            NotificationCenter.default.addObserver(
                spinner,
                selector: #selector(MKNSpinner.updateFrame),
                name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
                object: nil)
        }
        
        
        spinner.isShown = true
        return spinner
    }
    
    open  func hide(_ completion: (() -> Void)? = nil) {
        
        let spinner = MKNSpinner.sharedInstance
        
        NotificationCenter.default.removeObserver(spinner)
        
        DispatchQueue.main.async(execute: {
            UIApplication.shared.endIgnoringInteractionEvents()
            //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            spinner.isUserInteractionEnabled = true
            if spinner.superview == nil {
                spinner.isShown = false
                return
            }
            
            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
                spinner.alpha = 0.0
                }, completion: {_ in
                    spinner.alpha = 1.0
                    spinner.removeFromSuperview()
                    
                    spinner.isShown = false
                    completion?()
            })
        })
        
    }
}
