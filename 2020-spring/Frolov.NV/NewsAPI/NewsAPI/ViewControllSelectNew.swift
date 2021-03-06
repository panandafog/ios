//
//  ViewControllSelectNew.swift
//  NewsAPI
//
//  Created by Никита Фролов  on 25.03.2020.
//  Copyright © 2020 Никита Фролов . All rights reserved.
//

import UIKit

class ViewControllSelectNew: UIViewController {
    @IBOutlet var imageNews:UIImageView!
    @IBOutlet var labelNewsTitle:UILabel!
    @IBOutlet var labelNewsAuthor:UILabel!
    @IBOutlet var labelNewsDiscription:UILabel!
    private var imageLoadTask: URLSessionTask?
    
    var news:OneNew!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelNewsTitle.text = news.title
        labelNewsAuthor.text = news.author
        labelNewsDiscription.text = news.description
        
        guard let imageUrl = URL(string: news.urlToImage ?? "") else {return}
        imageLoadTask = URLSession.shared.dataTask(with: imageUrl) {data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.imageNews.image = image
            }
        }
        imageLoadTask?.resume()
    }
    
}
