//
//  RootBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook on 2023/05/26.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {}

final class RootComponent: Component<RootDependency> {}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)
        
        let searchBuilder = SearchBuilder(dependency: component)
        return RootRouter(
            interactor: interactor,
            viewController: viewController,
            searchBuilder: searchBuilder
        )
    }
}

extension RootComponent: SearchDependency {}
