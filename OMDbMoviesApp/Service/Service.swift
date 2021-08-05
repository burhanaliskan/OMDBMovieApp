//
//  Service.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 3.08.2021.
//

import Foundation
import Alamofire

protocol ServiceDelegate {
    func didUpdateMoviesSearch(_ service: Service, movieModel: [MovieModel])
    func didUpdateMovies(_ service: Service, movieModel: MovieModel)
    func didFailWithError(error: Error)
}

class Service {
    
    let baseUrl = Api.baseUrl
    
    var delegate: ServiceDelegate?
    
    //MARK: - getSearchMovies Request
    func getSearchMovies(with searchQuery: String) {
        let url = baseUrl + "?apikey=" + Api.apiKey + "&s=" + searchQuery
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            guard let moviesSearch = self.parseJsonCollection(data) else {return}
            self.delegate?.didUpdateMoviesSearch(self, movieModel: moviesSearch)
        }
    }
    
    //MARK: - getSearchMovies Request
    func getMovies(with imdbId: String) {
        let url = baseUrl + "?apikey=" + Api.apiKey + "&i=" + imdbId
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            guard let movies = self.parseJson(data) else {return}
            self.delegate?.didUpdateMovies(self, movieModel: movies)
        }
    }
    
    //MARK: - Parsing to Data Collection
    func parseJsonCollection(_ moviesData: Data) -> [MovieModel]? {
        let decoder = JSONDecoder()
        var movieDataList: [MovieModel] = []
        
        do {
            let decodeData = try decoder.decode(MoviesSearchData.self, from: moviesData)
            if let data = decodeData.Search {
                for index in 0 ... data.count - 1 {
                    let title = data[index].Title
                    let year = data[index].Year
                    let releasedDate = data[index].Released
                    let description = data[index].Plot
                    let picture = data[index].Poster
                    let rating = data[index].imdbRating
                    let imdbId = data[index].imdbID
                    let type = data[index].Type
                    let genre = data[index].Genre
                    let director = data[index].Director
                    let actors = data[index].Actors
                    
                    let movie = MovieModel(title: title, year: year, releasedDate: releasedDate, description: description, picture: picture, imdbRating: rating, imdbID: imdbId, type: type, genre: genre, director: director, actors: actors)
                    movieDataList.append(movie)
                }
            }
            return movieDataList
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    //MARK: - Parsing to Data
    func parseJson(_ moviesData: Data) -> MovieModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(MoviesData.self, from: moviesData)
            
            let title = decodeData.Title
            let year = decodeData.Year
            let releasedDate = decodeData.Released
            let description = decodeData.Plot
            let picture = decodeData.Poster
            let rating = decodeData.imdbRating
            let imdbId = decodeData.imdbID
            let type = decodeData.Type
            let genre = decodeData.Genre
            let director = decodeData.Director
            let actors = decodeData.Actors
            
            let movie = MovieModel(title: title, year: year, releasedDate: releasedDate, description: description, picture: picture, imdbRating: rating, imdbID: imdbId, type: type, genre: genre, director: director, actors: actors)
            
            
            return movie
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
