//
//  AlertManager.swift
//  ElevateChicago
//
//  Created by Sam Siner on 6/22/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class AlertManager {
  
    static func pullAlerts(completionHandler: @escaping (_ alerts: Alert) -> Void) {
        print("Pulling alerts")
        
        guard let url = URL(string: "https://lapi.transitchicago.com/api/1.0/alerts.aspx?outputType=JSON") else {
            print("Invalid URL")
            return
        }
                        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error!")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Bad HTTP status code!")
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
        
            do{
                let alerts = try JSONDecoder().decode(Alert.self, from: data!)
                
                DispatchQueue.main.async {
                    completionHandler(alerts)
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
