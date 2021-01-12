//
//  DeviceUtils.swift
//  ToDoList
//
//  Created by flock on 30/12/20.
//

import UIKit

class DeviceUtils: NSObject {

    class func returnDeviceSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
          
    class func openDeviceSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
}
