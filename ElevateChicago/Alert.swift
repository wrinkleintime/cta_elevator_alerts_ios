//
//  Alert.swift
//  ElevateChicago
//
//  Created by Sam Siner on 6/22/20.
//  Copyright © 2020 Sam Siner. All rights reserved.
//
import UIKit

struct Alert: Codable {
    var ctaAlerts: AlertContainerJSON
    
    enum CodingKeys: String, CodingKey {
        case ctaAlerts = "CTAAlerts"
    }
    
    struct AlertContainerJSON: Codable {
        var alerts: [AlertJSON]
        
        enum CodingKeys: String, CodingKey {
            case alerts = "Alert"
        }
        
        struct AlertJSON: Codable {
            var impact: String
            var shortDescription: String
            var headline: String
            var impactedService: ImpactedServiceContainer
            
            enum CodingKeys: String, CodingKey {
                case impact = "Impact"
                case shortDescription = "ShortDescription"
                case headline = "Headline"
                case impactedService = "ImpactedService"
            }
            
            struct ImpactedServiceContainer: Codable{
                var service: [ImpactedService]
                
                enum CodingKeys: String, CodingKey{
                    case service = "Service"
                }
                
                //Sometimes service comes in as an object, sometimes as an array
                init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    do {
                        let serviceSingle = try container.decode(ImpactedService.self, forKey: .service)
                        service = [serviceSingle]
                    } catch DecodingError.typeMismatch {
                        service = try container.decode([ImpactedService].self, forKey: .service)
                    }
                }
                
                struct ImpactedService: Codable{
                    var serviceType: String
                    var serviceId: String
                    
                    enum CodingKeys: String, CodingKey{
                        case serviceType = "ServiceType"
                        case serviceId = "ServiceId"
                    }
                }
            }
        }
    }
}









