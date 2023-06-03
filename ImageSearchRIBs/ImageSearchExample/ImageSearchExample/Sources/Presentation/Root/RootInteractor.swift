//
//  RootInteractor.swift
//  ImageSearchExample
//
//  Created by ChanWook on 2023/05/26.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
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
