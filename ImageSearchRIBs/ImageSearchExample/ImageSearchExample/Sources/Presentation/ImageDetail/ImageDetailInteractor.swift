//
//  ImageDetailInteractor.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/28.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

protocol ImageDetailRouting: ViewableRouting {}

protocol ImageDetailPresentable: Presentable {
    var listener: ImageDetailPresentableListener? { get set }
}

protocol ImageDetailListener: AnyObject {}

struct ImageDetailPresentableInputs {
    let updateFavorite = PublishRelay<Void>()
}
struct ImageDetailPresentableOutputs {
    let imageURLString: String
    let isAddFavorites: Driver<Bool>
}

final class ImageDetailInteractor: PresentableInteractor<ImageDetailPresentable>, ImageDetailInteractable, ImageDetailPresentableListener {
    
    let inputs = ImageDetailPresentableInputs()
    let outputs: ImageDetailPresentableOutputs

    weak var router: ImageDetailRouting?
    weak var listener: ImageDetailListener?

    private let disposeBag = DisposeBag()
    
    init(
        presenter: ImageDetailPresentable,
        imageURLString: String,
        fetchFavoritesUseCase: FetchFavoritesUseCaseType = FetchFavoritesUseCase()
    ) {
        let isAddFavoritesRelay = BehaviorRelay<Bool>(value: fetchFavoritesUseCase.isContains(imageURLString))
        
        inputs.updateFavorite
            .map { fetchFavoritesUseCase.update(imageURLString) }
            .bind(to: isAddFavoritesRelay)
            .disposed(by: disposeBag)
        
        outputs = .init(
            imageURLString: imageURLString,
            isAddFavorites: isAddFavoritesRelay.asDriver()
        )
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
