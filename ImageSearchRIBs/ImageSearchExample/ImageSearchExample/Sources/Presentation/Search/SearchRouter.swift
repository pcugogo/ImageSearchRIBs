//
//  SearchRouter.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/27.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs

protocol SearchInteractable: Interactable, ImageDetailListener {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {}

final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    private let imageDetailBuilder: ImageDetailBuilder
    
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
        viewController.uiviewController.navigationController?.pushViewController(
            imageDetail.viewControllable.uiviewController,
            animated: true
        )
    }
}
