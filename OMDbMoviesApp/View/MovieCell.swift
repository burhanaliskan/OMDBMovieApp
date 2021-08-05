//
//  MovieCell.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 4.08.2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Configure UI
    func configure(with imageLink: String, with title: String) {
        
        if title != Keywords.notFound {
            movieTitle.text = title
        } else {
            movieTitle.text = "Not Found"
        }
        
        if imageLink != Keywords.notFound {
            Helper.shared.setImage(with: imageLink, with: movieImageView, with: 15)
        } else {
            movieImageView.image = #imageLiteral(resourceName: "notFound")
        }
    }
}
