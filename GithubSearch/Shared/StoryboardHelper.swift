//
//  StoryboardHelper.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation

enum Storyboard: String, StoryboardProtocol {
    case main = "Main"
    
    var storyboardName: String {
        return self.rawValue
    }
}
