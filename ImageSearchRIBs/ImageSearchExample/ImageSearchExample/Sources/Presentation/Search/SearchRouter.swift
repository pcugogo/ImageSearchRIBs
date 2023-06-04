//
//  SearchRouter.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/27.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs
import RxSwift

protocol SearchInteractable: Interactable, ImageDetailListener {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    private let imageDetailBuilder: ImageDetailBuilder
    private let disposeBag = DisposeBag()
    
    init(
        interactor: SearchInteractable,
        viewController: SearchViewControllable,
        imageDetailBuilder: ImageDetailBuilder
    ) {
        self.imageDetailBuilder = imageDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToImageDetail(with imageURLString: String) {
        let imageDetail = imageDetailBuilder.build(withListener: interactor, imageURLString: imageURLString)
        attachChild(imageDetail)
        bindDetachWhenRoutingViewDisappears(routing: imageDetail)
        viewController.uiviewController.navigationController?.pushViewController(
            imageDetail.viewControllable.uiviewController,
            animated: true
        )
    }
    
    private func bindDetachWhenRoutingViewDisappears(routing: ViewableRouting) {
        routing.viewControllable.uiviewController.rx.viewDidDisappear
            .take(1)
            .subscribe(onNext: { [weak self, weak routing] _ in
                guard let routing = routing else { return }
                self?.detachChild(routing)
            })
            .disposed(by: disposeBag)
    }
}
