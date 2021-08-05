//
//  DetailViewController.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 4.08.2021.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieAverage: UILabel!
    @IBOutlet weak var movieRelaseDate: UILabel!
    @IBOutlet weak var imdbButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var movieId: String?
    
    let service = Service()
    var moviesData: MovieModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewConfigure()
    }
    
    func viewConfigure() {
        movieTitle.text = ""
        movieDescription.text = ""
        movieAverage.text = ""
        movieRelaseDate.text = ""
        
        service.delegate = self
        configureSetImageButton()
        service.getMovies(with: movieId!)
        Helper.shared.showSpinnerAnimation(spinner: spinner)
    }
    
    @IBAction func imdbButtonPressed(_ sender: UIButton) {
        guard let imdb = moviesData?.imdbID else { return }
        UIApplication.shared.openURL(URL(string: Api.imdbLink + imdb)!)
    }
    
    //MARK: - Set ButtonImdb
    func configureSetImageButton() {
        let image = #imageLiteral(resourceName: "ImdbLogo")
        imdbButton.setBackgroundImage(image, for: .normal)
        imdbButton.addTarget(self, action: #selector(self.imdbButtonPressed(_:)), for: .touchUpInside)
    }
    
    func configure() {
        
        if moviesData?.title != Keywords.notFound {
            movieTitle.text = moviesData?.title
        }
        
        if moviesData?.description != Keywords.notFound {
            movieDescription.text = moviesData?.description
        }
        
        if moviesData?.imdbRating != Keywords.notFound {
            movieAverage.text = moviesData?.imdbRating
        }
       
        if moviesData?.releasedDate != Keywords.notFound {
            movieRelaseDate.text = moviesData?.releasedDate
        }
        
        if moviesData?.picture != Keywords.notFound {
            Helper.shared.setImage(with: (moviesData?.picture!)!, with: movieImage)
        } else {
            movieImage.image = #imageLiteral(resourceName: "notFound")
        }
        
        Analytics.logEvent(EventAnalytics.movieTitleName, parameters: [EventAnalytics.movieTitleParametersName : moviesData?.title])
        Analytics.logEvent(EventAnalytics.movieAverageName, parameters: [EventAnalytics.movieAverageParametersName : moviesData?.imdbRating])
        Analytics.logEvent(EventAnalytics.movieReleaseDate, parameters: [EventAnalytics.movieReleaseDateParametersName : moviesData?.releasedDate])
    }
}

extension DetailViewController: ServiceDelegate {
    
    func didUpdateMovies(_ service: Service, movieModel: MovieModel) {
        DispatchQueue.main.async {
            self.moviesData = movieModel
            self.configure()
            Helper.shared.dismissSpinnerAnimation(spinner: self.spinner)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateMoviesSearch(_ service: Service, movieModel: [MovieModel]) {}
}
