//
//  NotificationUtils.swift
//  ToDoList
//
//  Created by flock on 01/01/21.
//

import UIKit

class NotificationUtils: NSObject {

    class func registerForNotifications(completion: @escaping CompletionHandler) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                completion()
                break
            case .notDetermined:
                AppDelegate.shared?.registerLocalNotifications(onSuccess: completion)
                break
            case .denied:
                DispatchQueue.main.async {
                    AlertUtils.showAlert(title: "Permission Denied", message:"Notification permission is denied. Please visit settings and turn on notifications for this application.", leftButtonTitle: "Cancel", leftButtonAction: nil, rightButtonTitle: "Settings", rightButtonAction: {
                        DeviceUtils.openDeviceSettings()
                    })
                }
                break
            default:
                DispatchQueue.main.async {
                    AlertUtils.showAlert(title: "Permission Issue", message: "Some unknown issue with notifications. Please visit settings and check if notifications are turned on for this application.", leftButtonTitle: "Cancel", leftButtonAction: nil, rightButtonTitle: "Settings", rightButtonAction: {
                        DeviceUtils.openDeviceSettings()
                    })
                }
            }
        }
    }
    
    class func scheduleNotification(title: String, subtitle: String, body: String, date: Date, notificationID: String?) {
        if notificationID != nil {
            self.registerForNotifications {
                let content                 = UNMutableNotificationContent()
                content.title               = title
                content.subtitle            = subtitle
                content.body                = body
                content.sound               = UNNotificationSound.default
                content.categoryIdentifier  = NotificationTypes.reminderNotification.rawValue
                
                let imageName = "notification.jpg"
                guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: nil) else { return }
                let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
                content.attachments = [attachment]
                
                let dateComponents = Calendar.current.dateComponents(Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute), from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: notificationID!, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
            }
        } else {
            print("Error in notification id")
        }
    }
    
    class func cancelLocalNotification(with notificationID: String?) {
        if notificationID != nil {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID!])
        }
    }
    
    //MARK:- Handling Notifications
    class func handleNotification(_ notification: UNNotification) {
        if notification.request.content.categoryIdentifier == NotificationTypes.reminderNotification.rawValue {
            let notificationID  = notification.request.identifier
            if let todoModel    = Todos.fetchTodoModels()?.filter({ $0.id == notificationID }).first {
                if let topController = SceneDelegate.shared?.window?.topViewController() {
                    if let viewControllers = topController.navigationController?.viewControllers {
                        for controller in viewControllers {
                            if let listViewController = controller as? TodoListViewController {
                                topController.navigationController?.popToViewController(listViewController, animated: false)
                                listViewController.handlePushNotification(todoModel: todoModel)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
