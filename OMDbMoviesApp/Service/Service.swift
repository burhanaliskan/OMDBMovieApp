//
//  Service.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 3.08.2021.
//

import Foundation
import Alamofire

protocol ServiceDelegate {
    func didFailWithError(error: Error)
}

class Service {
    
    let baseUrl = Api.baseUrl
    
    var delegate: ServiceDelegate?
    
    //MARK: - getSearchMovies Request
    func getSearchMovies(with searchQuery: String, completion: @escaping(MoviesSearchData) -> Void) {
        let url = baseUrl + "?apikey=" + Api.apiKey + "&s=" + searchQuery
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            guard let moviesSearch = self.parseJsonCollection(data) else {return}
            completion(moviesSearch)
        }
    }
    
    //MARK: - getMovie Request
    func getMovies(with imdbId: String, completion: @escaping(MoviesData) -> Void) {
        let url = baseUrl + "?apikey=" + Api.apiKey + "&i=" + imdbId
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            guard let movies = self.parseJson(data) else {return}
            completion(movies)
        }
    }
    
    //MARK: - Parsing to Data Collection
    func parseJsonCollection(_ moviesData: Data) -> MoviesSearchData? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(MoviesSearchData.self, from: moviesData)

            return decodeData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    //MARK: - Parsing to Data
    func parseJson(_ moviesData: Data) -> MoviesData? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(MoviesData.self, from: moviesData)

            return decodeData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
