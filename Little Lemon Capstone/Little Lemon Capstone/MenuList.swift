//
//  MenuList.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//

import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}

struct MenuItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let price: String
    let description: String?
    let category: String
}

