//
//  ViewController.swift
//  PPLoadingIndicator
//
//  Created by iffytheperfect1983 on 12/06/2018.
//  Copyright (c) 2018 iffytheperfect1983. All rights reserved.
//

import UIKit
import PPLoadingIndicator

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let button = UIButton(frame: CGRect(x: 200, y: 60, width: 100, height: 50))
    button.setTitle("Click here", for: .normal)
    button.addTarget(self, action: #selector((showLoadingIndicator)), for: .touchUpInside)
    button.setTitleColor(UIColor.blue, for: .normal)
    view.addSubview(button)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @objc
  func showLoadingIndicator() {
    let myView = UIView(frame: .init(x: 20, y: 150, width: 300, height: 300))
    myView.backgroundColor = UIColor.orange
    PPLoadingIndicator.useContainerView(view: myView)
    view.addSubview(myView)
//    PPLoadingIndicator.startAnimation(loadingIndicatorType: .singleCircle(color: UIColor.green, rotationType: .clockWise, rotationSpeed: .normal, animated: true))
    let loadingIndicatorType = LoadingIndicatorType.singleCircle(color: UIColor.purple, rotationType: .clockWise, rotationSpeed: .normal, animated: true)
    PPLoadingIndicator.startAnimation(duration: 5.0, loadingIndicatorType: loadingIndicatorType)
    
  }
  
}

