//
//  ViewFromNib.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 2/6/18.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func fromNib<T: UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutAttachAll(to: self)
        return view
    }
    
    private func layoutAttachAll(to view: UIView) {
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
