//
//  RootRouter.swift
//  ImageSearchExample
//
//  Created by ChanWook on 2023/05/26.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, SearchListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let searchBuilder: SearchBuildable
    
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        searchBuilder: SearchBuildable
    ) {
        self.searchBuilder = searchBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        routeToSearch()
    }
    
    // MARK: - Private
    
    private var search: ViewableRouting?
    
    private func routeToSearch() {
        let search = searchBuilder.build(withListener: interactor)
        self.search = search
        attachChild(search)
        viewController.replaceModal(viewController: search.viewControllable)
    }
}
