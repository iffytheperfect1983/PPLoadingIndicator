//
//  PPLoadingIndicator.swift
//  Pods-PPLoadingIndicator_Example
//
//  Created by Phanit Pollavith on 1/15/19.
//

import Foundation

public class PPLoadingIndicator: UIView {
  
  public class var sharedInstance: PPLoadingIndicator {
    struct Shared {
      static let instance = PPLoadingIndicator(frame: .zero)
    }
    return Shared.instance
  }
  
  //MARK: - Elements
  
  private lazy var outerCircleView = UIView()
  private lazy var innerCircleView = UIView()
  private let outerCircle = CAShapeLayer()
  private let innerCircle = CAShapeLayer()
  
  //MARK: - Init
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    let frameSize = CGSize(width: 200.0, height: 200.0)
    
    let blurEffectStyle: UIBlurEffect.Style = .dark
    let blurEffect = UIBlurEffect(style: blurEffectStyle)
    
    let blurView = UIVisualEffectView()
    addSubview(blurView)
    
    let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
    addSubview(vibrancyView)
    
    backgroundColor = UIColor.green
    
    let innerCirclePadding: CGFloat = 12
    innerCircle.path = UIBezierPath(ovalIn:
      CGRect(x: innerCirclePadding,
             y: innerCirclePadding,
             width: frameSize.width - 2 * innerCirclePadding,
             height: frameSize.height - 2 * innerCirclePadding))
      .cgPath
    innerCircle.lineWidth = 4.0
    innerCircle.strokeStart = 0.5
    innerCircle.strokeEnd = 0.9
    innerCircle.lineCap = .round
    innerCircle.fillColor = UIColor.clear.cgColor
    innerCircle.strokeColor = UIColor.blue.cgColor
    innerCircleView.layer.addSublayer(innerCircle)
    
    innerCircle.strokeStart = 0.0
    innerCircle.strokeEnd = 1.0
    
    blurView.contentView.addSubview(innerCircleView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
