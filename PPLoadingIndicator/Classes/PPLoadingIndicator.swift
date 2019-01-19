//
//  PPLoadingIndicator.swift
//  Pods-PPLoadingIndicator_Example
//
//  Created by Phanit Pollavith on 1/15/19.
//

import UIKit

public class PPLoadingIndicator: UIView {
  
  public class var sharedInstance: PPLoadingIndicator {
    struct Shared {
      static let instance = PPLoadingIndicator(frame: .zero)
    }
    return Shared.instance
  }
  
  public override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    blurEffect = UIBlurEffect(style: blurEffectStyle)
    blurView = UIVisualEffectView()
    addSubview(blurView)
    
    vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    addSubview(vibrancyView)
    
    blurView.contentView.addSubview(vibrancyView)
    
    innerCircleView.frame.size = frameSize
    
    let padding = CGFloat(15.0)
    innerCircle.path = UIBezierPath(ovalIn: CGRect(
      x: padding,
      y: padding,
      width: frameSize.width - 2 * padding,
      height: frameSize.height - 2 * padding)).cgPath
    innerCircle.lineWidth = 4.0
    innerCircle.strokeStart = 0.5
    innerCircle.strokeEnd = 0.9
    innerCircle.lineCap = .round
    innerCircle.fillColor = UIColor.clear.cgColor
    innerCircle.strokeColor = innerCircleDefaultColor
    innerCircleView.layer.addSublayer(innerCircle)
    
    innerCircle.strokeStart = 0.0
    innerCircle.strokeEnd = 1.0
    
    blurView.contentView.addSubview(innerCircleView)
    
    isUserInteractionEnabled = true
  }
  
  private let innerCircleDefaultColor = UIColor.gray.cgColor
  fileprivate var innerCircleColor: UIColor?
  
  public var innerColor: UIColor? {
    get {
      return innerCircleColor
    }
    set(newColor) {
      innerCircleColor = newColor
      innerCircle.strokeColor = newColor?.cgColor ?? innerCircleDefaultColor
    }
  }
  
  private static weak var customContainerView: UIView? = nil
  private static func containerView() -> UIView? {
    return customContainerView ?? UIApplication.shared.keyWindow
  }
  
  public class func useContainerView(view: UIView?) {
    customContainerView = view
  }
  
  @discardableResult
  public class func startAnimation(loadingIndicatorType: LoadingIndicatorType = LoadingIndicatorType.singleCircle(color: UIColor.blue, rotationType: .clockWise, rotationSpeed: .normal, animated: true)) -> PPLoadingIndicator {
    let loadingIndicator: PPLoadingIndicator
    switch loadingIndicatorType {
    case .singleCircle:
      loadingIndicator = animateSingleCircle(loadingIndicatorType)
    default:
      loadingIndicator = animateSingleCircle(loadingIndicatorType)
    }
    return loadingIndicator
  }
  
  @discardableResult
  public class func startAnimation(
    duration: Double,
    loadingIndicatorType: LoadingIndicatorType = LoadingIndicatorType.singleCircle(color: UIColor.blue, rotationType: .clockWise, rotationSpeed: .normal, animated: true)) -> PPLoadingIndicator {
    let loadingIndicator = PPLoadingIndicator.startAnimation(loadingIndicatorType: loadingIndicatorType)
    loadingIndicator.delay(duration) {
      PPLoadingIndicator.hide()
    }
    return loadingIndicator
  }
  
  public class func hide(_ completion: (() -> Void)? = nil) {
    let shared = PPLoadingIndicator.sharedInstance
    
    shared.dismissing = true
    
    NotificationCenter.default.removeObserver(shared)
    
    DispatchQueue.main.async(execute: {
      if shared.superview == nil {
        shared.dismissing = false
        return
      }
      
      UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut, animations: {
        shared.blurView.contentView.alpha = 0
        shared.blurView.effect = nil
      }, completion: {_ in
        shared.blurView.contentView.alpha = 1
        shared.removeFromSuperview()
        shared.dismissing = false
        completion?()
      })
      
      shared.animating = false
    })
  }
  
  public override var frame: CGRect {
    didSet {
      if frame == CGRect.zero {
        return
      }
      blurView.frame = bounds
      vibrancyView.frame = blurView.bounds
      innerCircleView.center = vibrancyView.center
    }
  }
  
  public var animating: Bool = false {
    
    willSet (shouldAnimate) {
      if shouldAnimate && !animating {
        spinInnerCircle()
      }
    }
    
    didSet {
      if animating {
        self.innerCircle.strokeStart = 0.5
        self.innerCircle.strokeEnd = 0.9
      } else {
        self.innerCircle.strokeStart = 0.0
        self.innerCircle.strokeEnd = 1.0
      }
    }
  }
  
  private var blurEffectStyle: UIBlurEffect.Style = .dark
  private var blurEffect: UIBlurEffect!
  private var blurView: UIVisualEffectView!
  private var vibrancyView: UIVisualEffectView!
  
  let frameSize = CGSize(width: 50.0, height: 50.0)
  
  private lazy var innerCircleView = UIView()
  
  private let innerCircle = CAShapeLayer()
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("Needs implementation")
  }
  
  private var currentRotation: CGFloat = 0.1
  private var rotationType: RotationType = .counterClockwise
  private var rotationSpeed: RotationSpeed = .normal
  private var dismissing: Bool = false
  
  @objc public func updateFrame() {
    if let containerView = PPLoadingIndicator.containerView() {
      PPLoadingIndicator.sharedInstance.frame = containerView.bounds
      containerView.bringSubviewToFront(PPLoadingIndicator.sharedInstance)
    }
  }
  
  func delay(_ seconds: Double, completion: @escaping VoidClosure) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
      completion()
    }
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    updateFrame()
  }
}

// Animations

extension PPLoadingIndicator {
  
  private func spinInnerCircle() {
    if superview == nil {
      return
    }
    UIView.animate(withDuration: rotationSpeed.rawValue, animations: {
      let rotation = CGFloat(Double.pi / 4)
      if self.rotationType == .clockWise {
        self.currentRotation += rotation
      } else {
        self.currentRotation -= rotation
      }
      self.innerCircleView.transform = CGAffineTransform(rotationAngle: self.currentRotation)
    }) { _ in
      if self.animating {
        self.spinInnerCircle()
      }
    }
  }
  
  @discardableResult
  private static func animateSingleCircle(_ loadingIndicatorType: LoadingIndicatorType) -> PPLoadingIndicator {
    
    let shared = PPLoadingIndicator.sharedInstance
    shared.innerColor = loadingIndicatorType.singleCircleColor
    shared.rotationType = loadingIndicatorType.singleCircleRotationType ?? RotationType.counterClockwise
    if let speed = loadingIndicatorType.singleCircleRotationSpeed {
      shared.rotationSpeed = speed
    }
    shared.updateFrame()
    
    if shared.superview == nil {
      shared.blurView.contentView.alpha = 0
      guard let containerView = containerView() else {
        fatalError("containerView shouldn't be nil")
      }
      
      containerView.addSubview(shared)
      
      UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
        shared.blurView.contentView.alpha = 1
        shared.blurView.effect = shared.blurEffect
      }, completion: nil)
      
      NotificationCenter.default.addObserver(
        shared,
        selector: #selector(PPLoadingIndicator.updateFrame),
        name: UIApplication.didChangeStatusBarOrientationNotification,
        object: nil)
    }
    
    shared.animating = loadingIndicatorType.singleCircleAnimating ?? true
    return shared
  }
}

public enum RotationType {
  case clockWise
  case counterClockwise
}

public enum RotationSpeed: Double {
  case slow = 0.24
  case normal = 0.13
  case fast = 0.05
}

public enum LoadingIndicatorType {
  case singleCircle(color: UIColor?, rotationType: RotationType, rotationSpeed: RotationSpeed, animated: Bool)
  case doubleCircle
  
  var singleCircleColor: UIColor? {
    switch self {
    case let .singleCircle(color, _, _, _): return color
    default: return nil
    }
  }
  
  var singleCircleRotationType: RotationType? {
    switch self {
    case let .singleCircle(_, rotationType, _, _): return rotationType
    default: return nil
    }
  }
  
  var singleCircleRotationSpeed: RotationSpeed? {
    switch self {
    case let .singleCircle(_, _, rotationSpeed, _): return rotationSpeed
    default: return nil
    }
  }
  
  var singleCircleAnimating: Bool? {
    switch self {
    case let .singleCircle(_, _, _, animated): return animated
    default: return nil
    }
  }
}
