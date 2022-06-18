import UserNotifications
import OneSignal
import os.log

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?
    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request;
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        
        
        let userDefaults = UserDefaults(suiteName: "group.com.kechaou.pushApp.onesignal")
        let player_id = userDefaults!.string(forKey: "GT_PLAYER_ID")
        NSLog("################ player_id \(player_id ?? "empty")" )
        
        
        let userInfo = request.content.userInfo
        
        let custom = userInfo["custom"] as? [String: Any]
        let arrAPS = userInfo["aps"] as? [String: Any]
        let arrAlert = arrAPS!["alert"] as? [String:Any]
        
        let not_id:String = custom!["i"] as? String ?? ""
        let strTitle:String = arrAlert!["title"] as? String ?? ""
        let strBody:String = arrAlert!["body"] as? String ?? ""
        
//        NSLog("###### Running NotificationServiceExtension: userInfo.description = \(userInfo.description)")
//        NSLog("####### Running NotificationServiceExtension: custom = \(custom.debugDescription)")
        let received_time = Date()
        let received_time_formatter = DateFormatter()
        received_time_formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        
        NSLog("####### Running NotificationServiceExtension: received_time = \(received_time_formatter.string(from: received_time))")
        NSLog("####### Running NotificationServiceExtension: not_id = \(not_id)")
        NSLog("####### Running NotificationServiceExtension: strTitle = \(strTitle)")
        NSLog("####### Running NotificationServiceExtension: strBody = \(strBody)")

        
        NSLog("###### send req")
        // Create URL
        let url = URL(string: "https://push-notification-admin-panel.herokuapp.com/api/receivedNotification?isIOS=true")
        guard let requestUrl = url else { fatalError() }

        // Create URL Request
        var request_post = URLRequest(url: requestUrl)

        // Specify HTTP Method to use
        request_post.httpMethod = "POST"
        request_post.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: AnyHashable] = [
            "user_id" :player_id,
            "title": strTitle,
            "content": strBody,
            "received_time": received_time_formatter.string(from: received_time),
            "notification_id": not_id
        ]
        
        request_post.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
       

        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request_post) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                NSLog("######## Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                NSLog("######### Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                NSLog("########### Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
        
        

      //debug log types need to be enabled in Console > Action > Include Debug Messages
        os_log("%{public}@", log: OSLog(subsystem: "com.kechaou.pushApp", category: "OneSignalNotificationServiceExtension"), type: OSLogType.debug, userInfo.debugDescription)
        
        if let bestAttemptContent = bestAttemptContent {
            OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
            
            //bestAttemptContent.body = "[Modified2] " + bestAttemptContent.body
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent, withContentHandler: self.contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
}
