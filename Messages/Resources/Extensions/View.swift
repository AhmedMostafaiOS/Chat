//
//  View.swift
//  Tasheel
//
//  Created by Abed Nayef Qasim on 8/6/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import UIKit
extension UIView {
    internal func loadViewFromNib(viewClass: Swift.AnyClass) -> UIView! {
        let bundle = Bundle(for: viewClass.self)
        let nib = UINib(nibName: String(describing: viewClass.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return view
    }
    
}


