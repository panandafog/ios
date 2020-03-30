//
//  MemeCell.swift
//  HW2
//
//  Created by panandafog on 20.03.2020.
//  Copyright © 2020 panandafog. All rights reserved.
//

import Kingfisher
import UIKit

class MemeCell: UITableViewCell {
    @IBOutlet private var label: UILabel!
    @IBOutlet private var picture: ScalingUIImageView!

    static var viewController: UIViewController?

    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = nil
        picture.kf.cancelDownloadTask()
    }

    func setup(with meme: Post, controller: ViewController, index: IndexPath) {

//        self.viewController = controller

        label.text = meme.title
        guard let url = meme.images?[0].url else { return }
        let tmpImage = self.picture.image
        picture.kf.setImage(with: url) { result in
            // `result` is either a `.success(RetrieveImageResult)` or a `.failure(KingfisherError)`
            switch result {
            case .success(let value):
                print(value.cacheType)
                if value.cacheType == .disk {
                    controller.updateCell(row: index.row, section: index.section)
                } else {
                    print("уже есть")
                }
            case .failure(let error):
                print(error) // The error happens
            }
        }
    }
}
