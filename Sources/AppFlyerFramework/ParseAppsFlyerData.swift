//
//  ParseAppsFlyerData.swift
//  
//
//  Created by AppsFlyer
//
import Foundation

final class ParseAppsFlyerData {
    
    var installCompletion: ((Install?) -> Void)?
    
    func parseCampaign(_ conversionInfo: [AnyHashable : Any]) {
        switch afStatus(conversionInfo: conversionInfo) {
            case .none:
                installCompletion?(nil)
            case .organic:
                installCompletion?(.organic)
            case .nonOrganic:
                let parameters = self.createParameters(conversionInfo: conversionInfo)
                installCompletion?(.nonOrganic(parameters))
        }
    }
    
    private func afStatus(conversionInfo: [AnyHashable : Any]) -> AfStatus {
        guard let afStatus = conversionInfo["af_status"] as? String else { return .none }
        guard let status = AfStatus(rawValue: afStatus) else { return .none }
        return status
    }
    
    private func createParameters(conversionInfo: [AnyHashable : Any]) -> [String: String] {
        var parameters: [String: String] = [:]
        conversionInfo.forEach({ key, value in
            if let key = key as? String, let value = value as? String, let keyCreate = Key(rawValue: key) {
                let keyParameter = getAnalog(key: keyCreate)
                let valueParameter = value
                parameters.updateValue(valueParameter, forKey: keyParameter)
            }
        })
        
        return parameters
    }
    
    private func getAnalog(key: Key) -> String {
        switch key {
            case .pid:
                return Analog.utmSource.rawValue
            case .af_channel:
                return Analog.utmMedium.rawValue
            case .c:
                return Analog.utmCampaign.rawValue
            case .af_adset:
                return Analog.utmContent.rawValue
            case .af_ad:
                return Analog.utmTerm.rawValue
                
            case .app_type:
                return Analog.appType.rawValue
            case .mb_uuid:
                return ""
            case .a_ssid:
                return ""
        }
    }
    
    init(){}
}
