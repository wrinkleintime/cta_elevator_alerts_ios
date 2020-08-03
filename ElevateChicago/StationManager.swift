//
//  StationManager.swift
//  ElevateChicago
//
//  Created by Sam Siner on 6/22/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//

import UIKit

class StationManager {
  
    static func pullStations(completionHandler: @escaping (_ stations: [CtaStation]) -> Void) {
        print("Pulling stations")
        
        guard let url = URL(string: "https://data.cityofchicago.org/resource/8pix-ypme.json") else {
            print("Invalid URL")
            return
        }
                        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorNotConnectedToInternet {
                    print("Not connected")
                } else {
                    print("Error!")
                }
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
                let stations = try JSONDecoder().decode([CtaStation].self, from: data!)
                
                DispatchQueue.main.async {
                    completionHandler(stations)
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
