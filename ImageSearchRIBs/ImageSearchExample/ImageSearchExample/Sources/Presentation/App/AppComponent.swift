//
//  AppComponent.swift
//  ImageSearchExample
//
//  Created by ChanWook on 2023/05/26.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
