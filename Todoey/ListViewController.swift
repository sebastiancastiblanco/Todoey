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
    
    var arrayName =  [ "ionic Android", "Udemy iOS", "IMAX Jurasick Park"]
    // contenedor de la app para almacenar datos
    // UsersDefaults method
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        print("init test")
        super.viewDidLoad()
        
        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [String]{
            arrayName = items
        }
        
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
        cell.textLabel?.text = self.arrayName[indexPath.row]
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
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //variable temporal para guardar el inputext
        var textField = UITextField()
        // Crear un popup uialert para agregar un elemento
        let alert = UIAlertController(title: "Add New Todoey Item", message: "Message", preferredStyle: .alert)
        // Crear boton de accion
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            print("Success")
            // validacion de vacio
            // textField.text ?? "Vacio"
            self.arrayName.append(textField.text!)
            // guardar en el contendor de la app la lista
            self.defaults.set(self.arrayName, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
