//
//  PPLoadingIndicatorHelper.swift
//  Pods-PPLoadingIndicator_Example
//
//  Created by Phanit Pollavith on 12/6/18.
//

import Foundation

public typealias ValueClosure<T> = (T) -> Void
public typealias VoidClosure = () -> Void

public class PPLoadingIndicatorHelper {
  
  // 0.1.1
  public static let number = 2.0
  
  public static func getNumber() -> Double {
    return number
  }
}
