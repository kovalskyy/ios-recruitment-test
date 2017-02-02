//
//  ServerService.swift
//  iOSRecruitmentTest
//
//  Created by Kacper Kowalski on 02.02.2017.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import Gloss

class ServerService {
    
    let realm = try! Realm()
    var results = try! Realm().objects(ItemRealm.self).sorted(byKeyPath: "id")
    
    static let sharedInstance = ServerService()
    private let SERVER_URL = "http://192.168.1.101:8080/api/items"
    
    func downloadAndSaveItem() {
        
        Alamofire.request(SERVER_URL).responseJSON { response in
                    let items = [Item].from(jsonArray: response.result.value as! [Gloss.JSON])
                    print(items?[0] as Any)
                    // self.tableView.reloadData()
            
                    try! self.realm.write {
                        for item in items! {
                            let itemRealm = ItemRealm()
                            itemRealm.id = item.id!
                            itemRealm.name = item.name!
                            itemRealm.desc = item.descr!
                            itemRealm.icon = item.icon!
                            self.realm.add(itemRealm, update: true)
                            
                        }
                    }
                    let itemRealms = self.realm.objects(ItemRealm.self)
                    print(itemRealms[0])
                    
                    //self.results = self.realm.objects(ItemRealm.self)
                    // print(items?[0] as Any)
            }

        
        
        
        
        
        
    }
}
