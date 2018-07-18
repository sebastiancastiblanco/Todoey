//
//  ListViewController.swift
//  Todoey
//
//  Created by Sebastián Castiblanco on 18/07/18.
//  Copyright © 2018 Sebastián Castiblanco. All rights reserved.
//

import Foundation

import UIKit

class ListViewController: UITableViewController {
    
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
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(arrayName[indexPath.row])
        // mostrar un flash para saber cual seleccionamos
        tableView.deselectRow(at: indexPath, animated: true)
        // Marca de verificacion, checkbox si ya tiene o no check
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
    }
    
}
