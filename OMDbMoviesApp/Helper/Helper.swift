//
//  Helper.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 4.08.2021.
//

import UIKit
import Kingfisher

struct Helper {
    
    static let shared = Helper()
    
    //MARK: - Set ImageView
    func setImage(with imageLink: String, with imageView: UIImageView) {
        let url = URL(string: imageLink)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                     
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    //MARK: - Set ImageView with Corner Radius
    func setImage(with imageLink: String, with imageView: UIImageView, with cornerRadius: CGFloat) {
        let url = URL(string: imageLink)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    //MARK: - CollectionView Spinner Show
    func showSpinnerAnimation(spinner: UIActivityIndicatorView, collectionView: UICollectionView) {
        DispatchQueue.main.async {
            spinner.startAnimating()
            UIView.animate(withDuration: 1) {
                collectionView.alpha = 0.5
            }
        }
    }
    
    //MARK: - CollectionView Spinner Dismiss
    func dismissSpinnerAnimation(spinner: UIActivityIndicatorView, collectionView: UICollectionView) {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            UIView.animate(withDuration: 1) {
                collectionView.alpha = 1
                spinner.isHidden = true
            }
        }
        
    }
    
    //MARK: - Spinner Show
    func showSpinnerAnimation(spinner: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            spinner.startAnimating()
        }
    }
    
    //MARK: - Spinner Dismiss
    func dismissSpinnerAnimation(spinner: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
}
