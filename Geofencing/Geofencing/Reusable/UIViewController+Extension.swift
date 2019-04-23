//
//  UIViewController+Extension.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 22/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private func initBarButton(image: UIImage, tintColor: UIColor = .white) -> UIButton {
        let newImage = image.withRenderingMode(.alwaysTemplate)
        let button = UIButton.init(type: .system)
        button.frame = .init(origin: .zero, size: .init(width: 40, height: 40))
        button.setImage(newImage, for: [])
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = tintColor
        
        return button
    }
    
    func getStoryboardVC(_ byName: String) -> UIViewController? {
        return self.storyboard?.instantiateViewController(withIdentifier: byName)
    }
    
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func addRightIndicator() {
        let indicator = UIActivityIndicatorView.init(style: .gray)
        indicator.frame = .init(origin: .zero, size: .init(width: 40, height: 40))
        indicator.color = Color.primary
        indicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: indicator)
    }
    
    func removeRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func addRightIcon(_ icon: UIImage) {
        let button = initBarButton(image: icon, tintColor: Color.primary)
        button.addTarget(self, action: #selector(onClickRightButtonItem), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
    @objc func onClickRightButtonItem() {
        
    }
    
    func addLeftIcon(_ icon: UIImage) {
        let button = initBarButton(image: icon, tintColor: Color.primary)
        button.addTarget(self, action: #selector(onClickLeftButtonItem), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
    @objc func onClickLeftButtonItem() {
        popVC()
    }
    
    func pushVC(_ identifier: String) {
        guard let nvc = self.navigationController, let controller = getStoryboardVC(identifier) else {
            return
        }
        nvc.pushViewController(controller, animated: true)
    }
    
    func popVC() {
        guard let nvc = self.navigationController else {
            return
        }
        _ = nvc.popViewController(animated: true)
    }
}
