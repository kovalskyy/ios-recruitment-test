//
//  RealmObject.swift
//  iOSRecruitmentTest
//
//  Created by Kacper Kowalski on 02.02.2017.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Foundation
import RealmSwift

class ItemRealm: Object {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var icon = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
