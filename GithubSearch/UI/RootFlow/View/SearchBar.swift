//
//  SearchBar.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {
    
    var isLoading: Bool {
        get {
            return self.activityIndicator != nil
        }
        set {
            if newValue {
                self.activityIndicator.ifNone {
                    let newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = .white
                    self.textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = self.textField?.leftView?.frame.size ?? .zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width / 2,
                                                          y: leftViewSize.height / 2)
                }
            } else {
                self.activityIndicator?.removeFromSuperview()
            }
        }
    }
    
    private var textField: UITextField? {
        return self.subviews.first?.subviews.compactMap { $0 as? UITextField }.first
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return self.textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.showsCancelButton = true
        self.delegate = self
    }
}

extension SearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        return Range(range,
                     in: searchBar.text.unwrapped).flatMap {
            searchBar
                .text
                .unwrapped
                .replacingCharacters(in: $0,
                                     with: text)
                .count <= 30
        } ?? false
    }
}
