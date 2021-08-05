//
//  Constants.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 4.08.2021.
//

import Foundation

enum Api {
    static let baseUrl = "https://www.omdbapi.com/"
    static let apiKey = "61aef5f4"
    static let imdbLink = "https://www.imdb.com/title/"
}

enum CellNibName {
    static let movieCellNibName = "MovieCell"
}

enum CellIdentifier {
    static let movieCellIdentifier = "MovieCellIdentifier"
}

enum Segue {
    static let goToHomeView = "HomeViewController"
    static let goToErrorView = "ErrorViewController"
    static let goToDetailView = "DetailViewController"
}

enum EventAnalytics {
    static let movieTitleName = "Movie_Title"
    static let movieAverageName = "Movie_Average"
    static let movieReleaseDate = "Movie_ReleaseDate"
    
    static let movieTitleParametersName = "movieTitle"
    static let movieAverageParametersName = "movieAverage"
    static let movieReleaseDateParametersName = "movieReleaseDate"
}
