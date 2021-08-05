//
//  HomeViewController.swift
//  OMDbMoviesApp
//
//  Created by Burhan Alışkan on 3.08.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let service = Service()
    var moviesSearchDataList: [MovieModel] = []
    var index = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.delegate = self
        searchBar.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        movieCollectionView.register(UINib(nibName: CellNibName.movieCellNibName, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.movieCellIdentifier)
        service.getSearchMovies(with: "fight")
        Helper.shared.showSpinnerAnimation(spinner: spinner, collectionView: movieCollectionView)
    }
}

//MARK: - ServiceDelegate
extension HomeViewController: ServiceDelegate {
    func didUpdateMoviesSearch(_ service: Service, movieModel: [MovieModel]) {
        DispatchQueue.main.async {
            self.moviesSearchDataList = movieModel
            Helper.shared.dismissSpinnerAnimation(spinner: self.spinner, collectionView: self.movieCollectionView)
            
            if self.moviesSearchDataList.count > 0 {
                self.movieCollectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "Error", message: "The movie you searched is not found!!!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                service.getSearchMovies(with: "fight")
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateMovies(_ service: Service, movieModel: MovieModel) {}
}

//MARK: - Segue Transfer
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVc = segue.destination as? DetailViewController
        
        if segue.identifier == Segue.goToDetailView {
                detailVc?.movieId = moviesSearchDataList[index].imdbID
        }
    }
}

//MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        service.getSearchMovies(with: searchBarText)
        self.searchBar.endEditing(true)
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesSearchDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.movieCellIdentifier , for: indexPath) as! MovieCell
        
        cell.configure(with: moviesSearchDataList[indexPath.row].picture!, with: moviesSearchDataList[indexPath.row].title!)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: Segue.goToDetailView, sender: self)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
}


