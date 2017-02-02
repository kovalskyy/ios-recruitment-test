//
//  Item.swift
//  iOSRecruitmentTest
//
//  Created by Kacper Kowalski on 02.02.2017.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Foundation
import RealmSwift
import Gloss

struct Item: Decodable {
    
    let id: Int?
    let name: String?
    let descr: String?
    let icon: String?
    let url: String?
    
    init?(json: JSON) {
        self.id = ("id" <~~ json)
        self.name =  ("name" <~~ json)
        self.descr =  ("description" <~~ json)
        self.icon =  ("icon" <~~ json)
        self.url =  ("url" <~~ json)
    }
}
