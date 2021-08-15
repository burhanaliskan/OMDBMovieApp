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
    var moviesSearchDataList: MoviesSearchData?
    var index = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    func configure() {
        service.delegate = self
        searchBar.delegate = self
        setCollectionCell()
        getMovies("fight")
        Helper.shared.showSpinnerAnimation(spinner: spinner, collectionView: movieCollectionView)
    }
    
    func getMovies(_ title: String) {
        service.getSearchMovies(with: title) { movieSearch in
            self.moviesSearchDataList = movieSearch
            
            if self.moviesSearchDataList?.Search?.count ?? 0 > 0 {
                Helper.shared.dismissSpinnerAnimation(spinner: self.spinner, collectionView: self.movieCollectionView)
                self.movieCollectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "Error", message: "The movie you searched is not found!!!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.getMovies("fight")
            }
        }
    }
    
    func setCollectionCell() {
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        movieCollectionView.register(UINib(nibName: CellNibName.movieCellNibName, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.movieCellIdentifier)
    }
}

//MARK: - ServiceDelegate
extension HomeViewController: ServiceDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Segue Transfer
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVc = segue.destination as? DetailViewController
        
        if segue.identifier == Segue.goToDetailView {
            detailVc?.movieId = moviesSearchDataList?.Search?[index].imdbID
        }
    }
}

//MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        getMovies(searchBarText)
        self.searchBar.endEditing(true)
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesSearchDataList?.Search?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.movieCellIdentifier , for: indexPath) as! MovieCell
        
        var imageLink = ""
        var title = ""
        
        if let linkImage = moviesSearchDataList?.Search?[indexPath.row].Poster {
            imageLink = linkImage
        }
        
        if let movieTitle = moviesSearchDataList?.Search?[indexPath.row].Title {
            title = movieTitle
        }
        
        cell.configure(with: imageLink, with: title)
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


