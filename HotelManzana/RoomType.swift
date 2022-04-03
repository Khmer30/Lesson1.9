//
//  RoomType.swift
//  HotelManzana
//
//  Created by Joy Marie on 3/28/22.
//

import Foundation

struct RoomType: Equatable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
}

func ==(lhs: RoomType, rhs: RoomType) -> Bool {
    return lhs.id == rhs.id
}
