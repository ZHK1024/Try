//
//  PersonViewController.swift
//  SyncDemo
//
//  Created by ZHK on 2018/7/23.
//  Copyright © 2018年 ZHK. All rights reserved.
//

import UIKit
import RealmSwift
import TextFieldEffects

class PersonViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var minour: YoshikoTextField?
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.alpha = 0
        
        minour = YoshikoTextField(frame: CGRect(x: 30, y: 80, width: 315, height: 60))
//        minour?.tintColor = UIColor.orange
        minour?.activeBorderColor = UIColor.orange
        minour?.inactiveBorderColor = UIColor.gray.withAlphaComponent(0.1)
        minour?.placeholderFontScale = 1.0
        minour?.placeholderColor = UIColor.gray.withAlphaComponent(0.5)
        
//        minour?.borderActiveColor = UIColor.orange
//        minour?.borderInactiveColor = UIColor.gray
        
        minour?.placeholder = "Name"
        self.view.addSubview(minour!)
        

//        print(minour)
        
        tableView.register(UITableViewCell().classForCoder, forCellReuseIdentifier: "cell")
        if person == nil {
            navigationItem.rightBarButtonItem = navigationItem.rightBarButtonItems?.first
        } else {
            textField.text = person?.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK:
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if textField.text?.count == 0 {
            return
        }
        if person == nil {
            addRecord()
        } else {
            saveRecord()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func addRecord() {
        let person = Person()
        person.name = textField.text!
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(person)
        }
    }
    
    func saveRecord() {
        let realm = person?.realm
        try! realm?.write {
            person?.name = textField.text!
        }
    }
    
    // MARK: TableView dataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person?.dogs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = person?.dogs[indexPath.row].name
        return cell!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dogVC = segue.destination as! DogViewController
        dogVC.person = person
    }
}
