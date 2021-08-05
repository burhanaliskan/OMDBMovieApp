//
//  ViewController.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 2.08.2021.
//

import UIKit
import Network

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var labelText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelText.text = ""
        NetworkMonitor.shared.startMonitoring(with: self)
        RemoteConfigs.shared.fetchValues(with: labelText)
    }
}

