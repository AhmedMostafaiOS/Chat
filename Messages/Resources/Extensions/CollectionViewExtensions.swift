//
//  CollectionViewExtensions.swift
//  LawyerUp
//
//  Created by Abed Nayef Qasim on 2/8/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import UIKit
extension UICollectionView {
    
    func register<T:UICollectionViewCell>(_: T.Type){
        let bundle = Bundle(for: T.self)
        let nib =  UINib(nibName: T.nibName, bundle: bundle)
        
        
        register(nib, forCellWithReuseIdentifier: T.nibName)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath)-> T{
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.nibName)")
        }
        
        return cell
    }
    
}


extension UICollectionViewCell:NibLoadableView{
    static var nibName:String {
        return String(describing: self)
    }
    
    
}
