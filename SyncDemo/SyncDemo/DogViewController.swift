//
//  DogViewController.swift
//  SyncDemo
//
//  Created by ZHK on 2018/7/23.
//  Copyright © 2018年 ZHK. All rights reserved.
//

import UIKit

class DogViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        let dog = Dog()
        dog.name = nameField.text!
        dog.age = Int(ageField.text!)!
        dog.owner = person
        let realm = person?.realm
        try! realm?.write {
            realm?.add(dog)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
