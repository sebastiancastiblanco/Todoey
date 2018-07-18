//
//  ViewController.swift
//  Todoey
//
//  Created by Sebastián Castiblanco on 26/06/18.
//  Copyright © 2018 Sebastián Castiblanco. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let arrayName =  [ "ionic Android", "Udemy iOS", "IMAX Jurasick Park"]
    
    override func viewDidLoad() {
        print("init test")
        super.viewDidLoad()
        
    }


    // MARK - TableView Datasource methos
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print( arrayName.count )
        return arrayName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print( arrayName[indexPath.row])
        // Enlazarse con una tabla y el identificador
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // agregar el label
        cell.textLabel?.text = arrayName[indexPath.row]
        // retornar el cell
        return cell
        
    }
    
}

