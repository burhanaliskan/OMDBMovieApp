//
//  RemoteConfig.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 3.08.2021.
//

import Foundation
import FirebaseRemoteConfig

struct RemoteConfigs {
    static let shared = RemoteConfigs()
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    //MARK: - Fetch Value
    func fetchValues(with label: UILabel) {
        let defaults: [String: NSObject]  = ["labelText": "defaultText" as NSObject]
        
        remoteConfig.setDefaults(defaults)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        self.remoteConfig.fetch(withExpirationDuration: 100) { status, error in
            if status == .success , error == nil {
                self.remoteConfig.activate { changed, error in
                    guard error == nil else {
                        return
                    }
                    if let value = self.remoteConfig.configValue(forKey: "labelText").stringValue {
                        updateUI(with: label, with: value)
                    }
                }
            } else {
                print("Something wrong")
            }
        }
    }
    
    //MARK: - Update Launch Screen label
    func updateUI(with label: UILabel, with labelText: String) {
        DispatchQueue.main.async {
            label.text = labelText
        }
    }
}
