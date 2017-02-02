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
    
    let realm = try! Realm()
    var results = try! Realm().objects(ItemRealm.self).sorted(byKeyPath: "id")
    
    private let SERVER_URL = "http://192.168.1.101:8080/api/items"
    
    var inSearchMode = false
    var filetered = [ItemRealm]()
    
    
    //MARK: - Pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
        
    }()
    
    func handleRefresh() {
        downloadAndSaveItem()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadAndSaveItem()
    
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.addSubview(self.refreshControl)
    }


    // MARK: - UITableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return self.filetered.count
        }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        var object: ItemRealm
        if (inSearchMode && filetered.count > 0) {
            object = self.filetered[indexPath.row] as ItemRealm
        } else {
            object = self.results[indexPath.row] as ItemRealm
        }
        
        cell.item = object
        return cell
    }
    
    //MARK: - UISeachBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        inSearchMode = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
        inSearchMode = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text?.capitalized
            
            filetered = results.filter({$0.name.range(of: lower!) != nil})
            tableView.reloadData()
        }
    }
    
    //MARK: - Network Connection
    func downloadAndSaveItem() {
        
        Alamofire.request(SERVER_URL).responseJSON { response in
            let items = [Item].from(jsonArray: response.result.value as! [Gloss.JSON])
            
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
            
            self.tableView.reloadData()
        }
    }
}
