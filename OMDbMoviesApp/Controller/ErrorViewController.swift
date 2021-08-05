//
//  ErrorViewController.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 3.08.2021.
//

import UIKit

class ErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Exit App
    @IBAction func closeAppPressed(_ sender: UIButton) {
        exit(0)
    }
    
}
