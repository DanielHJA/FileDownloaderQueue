//
//  ImageViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-18.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var object: DownloadObject?
    
    private lazy var scrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.delegate = self
        temp.showsVerticalScrollIndicator = false
        temp.showsHorizontalScrollIndicator = false
        temp.maximumZoomScale = 5.0
        temp.minimumZoomScale = 1.0
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var imageView: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFit
        scrollView.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        temp.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9).isActive = true
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureImage()
    }
    
    private func configureImage() {
        if let url = Storage.shared.urlForObject(object) {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                imageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
}

extension ImageViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                let ratio = ratioW < ratioH ? ratioW:ratioH
                let newWidth = image.size.width*ratio
                let newHeight = image.size.height*ratio

                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
