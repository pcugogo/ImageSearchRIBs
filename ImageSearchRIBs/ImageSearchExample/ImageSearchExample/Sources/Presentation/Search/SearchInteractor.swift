//
//  SearchInteractor.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/27.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import Foundation
import RIBs
import RxSwift
import RxCocoa

protocol SearchRouting: ViewableRouting {
    func routeToImageDetail(with imageURLString: String)
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
}

protocol SearchListener: AnyObject {}

struct SearchPresentableInputs {
    let searchWithKeyword = PublishRelay<String>()
    let willDisplayCellIndexPath = PublishRelay<IndexPath>()
    let selectedItemIndexPath = PublishRelay<IndexPath>()
}
struct SearchPresentableOutputs {
    let imageDatas: Driver<[ImageData]>
    let networkError: Signal<NetworkError>
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    
    var inputs = SearchPresentableInputs()
    var outputs: SearchPresentableOutputs

    weak var router: SearchRouting?
    weak var listener: SearchListener?
    
    private let disposeBag = DisposeBag()
    
    init(
        presenter: SearchPresentable,
        searchUseCase: SearchUseCaseType = SearchUseCase()
    ) {
        let imageDatasRelay = BehaviorRelay<[ImageData]>(value: [])
        let errorRelay = PublishRelay<NetworkError>()
        let pageRelay = BehaviorRelay<Int>(value: 1)
        let metaRelay = BehaviorRelay<Meta?>(value: nil)
        let currentKeywordRelay = BehaviorRelay<String>(value: "")
        
        outputs = SearchPresentableOutputs(
            imageDatas: imageDatasRelay.asDriver(),
            networkError: errorRelay.asSignal()
        )
        
        super.init(presenter: presenter)
        presenter.listener = self
        
        let searchWithKeyword = inputs.searchWithKeyword.asObservable()
            .map { (keyword: $0, page: 1) }
        
        let isLastPage = Observable.combineLatest(pageRelay, metaRelay)
            .map { $0 >= 50 || $1?.isEnd == true }
        
        let reachedThreshold = inputs.willDisplayCellIndexPath
            .withLatestFrom(imageDatasRelay) { (indexPath: $0, data: $1) }
            .filter { $0.data.count - 1 <= $0.indexPath.item }
        
        let loadMore = reachedThreshold
            .withLatestFrom(isLastPage)
            .filter { $0 == false }
            .withLatestFrom(currentKeywordRelay)
            .withLatestFrom(pageRelay, resultSelector: { (keyword: $0, page: $1 + 1) })
        
        Observable.merge(searchWithKeyword, loadMore)
            .flatMapLatest { keyword, page -> Observable<(response: SearchResponse, keyword: String, page: Int)> in
                return searchUseCase.search(keyword: keyword, page: page)
                    .catch {
                        errorRelay.accept($0 as? NetworkError ?? NetworkError.unknown)
                        return .empty()
                    }
                    .map { (response: $0, keyword: keyword, page: page) }
            }
            .subscribe(onNext: { response, keyword, page in
                let isFirstSearch = page == 1

                if isFirstSearch {
                    currentKeywordRelay.accept(keyword)
                }
                
                pageRelay.accept(page)
                
                let newImageDatas = isFirstSearch ? response.imageDatas : (imageDatasRelay.value + response.imageDatas)
                imageDatasRelay.accept(newImageDatas)
            })
            .disposed(by: disposeBag)
        
        inputs.selectedItemIndexPath
            .withLatestFrom(imageDatasRelay, resultSelector: { (indexPath: $0, datas: $1) })
            .map { $0.datas[$0.indexPath.item].imageURL }
            .subscribe(onNext: { [weak self] imageURLString in
                self?.router?.routeToImageDetail(with: imageURLString)
            })
            .disposed(by: disposeBag)
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
