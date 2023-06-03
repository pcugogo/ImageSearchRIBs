//
//  SearchBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/27.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import UIKit
import RIBs

protocol SearchDependency: Dependency {}

final class SearchComponent: Component<SearchDependency> {}

// MARK: - Builder

protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchListener) -> SearchRouting {
        let viewController = StoryboardName.main.instantiateStoryboard()
            .instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let interactor = SearchInteractor(presenter: viewController)
        interactor.listener = listener
        
        let component = SearchComponent(dependency: dependency)
        let imageDetailBuilder = ImageDetailBuilder(dependency: component)
        return SearchRouter(
            interactor: interactor,
            viewController: viewController,
            imageDetailBuilder: imageDetailBuilder
        )
    }
}
