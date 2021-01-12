//
//  Extensions.swift
//  ToDoList
//
//  Created by flock on 02/01/21.
//

import Foundation
import UIKit

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presentedController = top?.presentedViewController {
                top = presentedController
            } else if let navController = top as? UINavigationController {
                top = navController.visibleViewController
            } else if let tabController = top as? UITabBarController {
                top = tabController.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}

extension String {
    func height(with width: CGFloat) -> CGFloat {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        textView.text = self
        textView.sizeToFit()
        return textView.frame.height
    }
}
