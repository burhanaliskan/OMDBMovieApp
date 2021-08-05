//
//  Helper.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 2.08.2021.
//

import UIKit
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    //MARK: - Start Internet Monitoring
    func startMonitoring( with view: UIViewController) {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    view.dismiss(animated: true)
                    Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {  timer in
                        DispatchQueue.main.async {
                            if let networkVc = view.storyboard?.instantiateViewController(identifier: Segue.goToHomeView) as? HomeViewController {
                                networkVc.modalPresentationStyle = .fullScreen
                                view.present(networkVc, animated: true)
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let networkVc = view.storyboard?.instantiateViewController(identifier: Segue.goToErrorView) as? ErrorViewController {
                        networkVc.modalPresentationStyle = .fullScreen
                        view.present(networkVc, animated: true)
                    }
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    //MARK: - Stop Internet Monitoring
    func stopMonitoring() {
        monitor.cancel()
    }
}
