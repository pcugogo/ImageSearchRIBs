//
//  ImageDetailBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/28.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs

protocol ImageDetailDependency: Dependency {}

final class ImageDetailComponent: Component<ImageDetailDependency> {
    fileprivate let imageURLString: String
    
    init(dependency: ImageDetailDependency, imageURLString: String) {
        self.imageURLString = imageURLString
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ImageDetailBuildable: Buildable {
    func build(withListener listener: ImageDetailListener, imageURLString: String) -> ImageDetailRouting
}

final class ImageDetailBuilder: Builder<ImageDetailDependency>, ImageDetailBuildable {

    override init(dependency: ImageDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ImageDetailListener, imageURLString: String) -> ImageDetailRouting {
        let component = ImageDetailComponent(dependency: dependency, imageURLString: imageURLString)
        let viewController = StoryboardName.main.instantiateStoryboard()
            .instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        let interactor = ImageDetailInteractor(presenter: viewController, imageURLString: component.imageURLString)
        interactor.listener = listener
        return ImageDetailRouter(interactor: interactor, viewController: viewController)
    }
}
