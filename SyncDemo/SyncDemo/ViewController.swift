//
//  ViewController.swift
//  SyncDemo
//
//  Created by ZHK on 2018/7/23.
//  Copyright © 2018年 ZHK. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var persons: Results<Person>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell().classForCoder, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK:
    
    func loadData() {
        let realm = try! Realm()
        persons = realm.objects(Person.self)
        tableView.reloadData()
    }

    // MARK: TableView dataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let person = persons![indexPath.row]
        cell?.textLabel?.text = person.name
        return cell!
    }
    
    // MARK: TabelView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let personVC = sb.instantiateViewController(withIdentifier: "person") as! PersonViewController
        personVC.person = persons?[indexPath.row]
        navigationController?.pushViewController(personVC, animated: true)
    }
}

