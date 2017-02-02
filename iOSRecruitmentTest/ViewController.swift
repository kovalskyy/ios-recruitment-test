//
//  ViewController.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var inSearchMode = false
    var filetered = [ItemRealm]()
    
    let realm = try! Realm()
    var results = try! Realm().objects(ItemRealm.self).sorted(byKeyPath: "id")
    let SERVER_URL = "http://192.168.1.101:8080/api/items"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self.realm.add(itemRealm)
                    self.tableView.reloadData()
                }
            }
            let itemRealms = self.realm.objects(ItemRealm.self)
            print(itemRealms[0])
            
            //self.results = self.realm.objects(ItemRealm.self)
            // print(items?[0] as Any)
        }

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
      
    }


    // MARK: - UITableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        var object: ItemRealm
        object = self.results[indexPath.row] as ItemRealm
        
        cell.item = object
        
        return cell
    }
    
}
