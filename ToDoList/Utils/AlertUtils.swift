//
//  AlertUtils.swift
//  ToDoList
//
//  Created by flock on 01/01/21.
//

import UIKit

class AlertUtils: NSObject {

    class func showAlert(style: UIAlertController.Style = .alert, title: String?, message: String?, leftButtonTitle: String?, leftButtonStyle: UIAlertAction.Style = .default,  leftButtonAction: CompletionHandler?, rightButtonTitle: String?, rightButtonStyle: UIAlertAction.Style = .default, rightButtonAction: CompletionHandler?, controller: UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if leftButtonTitle != nil, leftButtonTitle!.count > 0 {
            alertController.addAction(UIAlertAction(title: leftButtonTitle, style: leftButtonStyle, handler: { (action) in
                leftButtonAction?()
            }))
        }
        if rightButtonTitle != nil, rightButtonTitle!.count > 0 {
            alertController.addAction(UIAlertAction(title: rightButtonTitle, style: rightButtonStyle, handler: { (action) in
                rightButtonAction?()
            }))
        }
        if controller != nil {
            controller!.present(alertController, animated: true, completion: nil)
        } else {
            SceneDelegate.shared?.window?.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showActionSheet(title: String?, message: String?, leftButtonTitle: String?, leftButtonStyle: UIAlertAction.Style = .default,  leftButtonAction: CompletionHandler?, rightButtonTitle: String?, rightButtonStyle: UIAlertAction.Style = .default, rightButtonAction: CompletionHandler?, controller: UIViewController? = nil) {
        showAlert(style: .actionSheet, title: title, message: message, leftButtonTitle: leftButtonTitle, leftButtonStyle: leftButtonStyle, leftButtonAction: leftButtonAction, rightButtonTitle: rightButtonTitle, rightButtonStyle: rightButtonStyle, rightButtonAction: rightButtonAction, controller: controller)
    }
    
}
