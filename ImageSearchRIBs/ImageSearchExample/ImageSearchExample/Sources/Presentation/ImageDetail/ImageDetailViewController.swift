//
//  ImageDetailViewController.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2023/05/28.
//  Copyright © 2023 ChanWookPark. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ImageDetailPresentableListener: AnyObject {
    var inputs: ImageDetailPresentableInputs { get }
    var outputs: ImageDetailPresentableOutputs { get }
}

final class ImageDetailViewController: UIViewController, ImageDetailPresentable, ImageDetailViewControllable {

    weak var listener: ImageDetailPresentableListener?
    
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindOutputs()
        bindInputs()
    }
}

extension ImageDetailViewController {
    // MARK: - Inputs
    func bindInputs() {
        guard let listener = listener else { return }
        
        favoriteButton.rx.tap
            .bind(to: listener.inputs.updateFavorite)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Outputs
    func bindOutputs() {
        guard let listener = listener else { return }
        
        if let url = URL(string: listener.outputs.imageURLString) {
            detailImageView.kf.setImage(with: url)
        }

        listener.outputs.isAddFavorites
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
