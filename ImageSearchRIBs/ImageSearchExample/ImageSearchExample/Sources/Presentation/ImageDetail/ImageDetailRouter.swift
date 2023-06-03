//
//  ImageDetailRouter.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/28.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs

protocol ImageDetailInteractable: Interactable {
    var router: ImageDetailRouting? { get set }
    var listener: ImageDetailListener? { get set }
}

protocol ImageDetailViewControllable: ViewControllable {}

final class ImageDetailRouter: ViewableRouter<ImageDetailInteractable, ImageDetailViewControllable>, ImageDetailRouting {

    override init(interactor: ImageDetailInteractable, viewController: ImageDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
