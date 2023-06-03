//
//  SearchViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/27.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol SearchPresentableListener: AnyObject {
    var inputs: SearchPresentableInputs { get }
    var outputs: SearchPresentableOutputs { get }
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?
    
    private let searchController = UISearchController()
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        bindOutputs()
        bindInputs()
    }
}

// MARK: - setup UIs
extension SearchViewController {
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}

extension SearchViewController {
    // MARK: - Inputs
    func bindInputs() {
        guard let listener = listener else { return }
        
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .do(onNext: { [weak self] in
                self?.searchController.dismiss(animated: true, completion: nil)
                
                if $0.isEmpty {
                    self?.showAlert(title: "", message: "검색어를 입력해 주세요.")
                }
            })
            .filter { $0.isEmpty == false }
            .bind(to: listener.inputs.searchWithKeyword)
            .disposed(by: disposeBag)
                
        collectionView.rx.willDisplayCell
            .map { $0.at }
            .bind(to: listener.inputs.willDisplayCellIndexPath)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(to: listener.inputs.selectedItemIndexPath)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Outputs
    func bindOutputs() {
        guard let listener = listener else { return }
        
        listener.outputs.imageDatas
            .drive(collectionView.rx.items) { collectionView, index, element in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ImageCollectionViewCell.self),
                    for: IndexPath(row: index, section: 0)
                ) as! ImageCollectionViewCell
                cell.setImage(urlString: element.imageURL)
                return cell
            }
            .disposed(by: disposeBag)
        
        listener.outputs.networkError
            .emit(onNext: { [weak self] error in
                self?.showAlert(title: "네트워크 오류", message: error.message)
            })
            .disposed(by: disposeBag)
    }
}
