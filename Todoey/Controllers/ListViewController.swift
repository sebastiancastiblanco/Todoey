//
//  ListViewController.swift
//  Todoey
//
//  Created by Sebastián Castiblanco on 18/07/18.
//  Copyright © 2018 Sebastián Castiblanco. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    //var arrayName =  [ "ionic Android", "Udemy iOS", "IMAX Jurasick Park"]
    var arrayName =  [Item]() // inicializar array de objetos
    // contenedor de la app para almacenar datos
    // UsersDefaults method
    let defaults = UserDefaults.standard
    // Contexto para usar CoreData y para poder salvar datos y persistirlos
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // varible para guardar la categoria seleccionada, cuando se setea se ejecuta el didSet
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        print("init test")
        super.viewDidLoad()
        // imprimir la ruta donde se almacena los datos de la app en una plist.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // define el delegado para algun tipo de elemento
        //searchbar.delegate = self
        // cargar elementos a la tabla, por defecto no se envia el request y se hace uso
        // del valor por defecto definido en el metodo
        
        loadItems()
        
        
       /* let newItem = Item()
        newItem.title = "Jaimito App"
        newItem.check = true
        let newItem2 = Item()
        newItem2.title = "Jaimito App 2"
        newItem2.check = true
        let newItem3 = Item()
        newItem3.title = "Jaimito App 3"
        newItem3.check = true
        
        arrayName.append(newItem)
        arrayName.append(newItem2)
        arrayName.append(newItem3)*/
        
        /*if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item]{
            arrayName = items
        }*/
        
    }
    
    
    // MARK: - TableView Datasource methos
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print( arrayName.count )
        return arrayName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Enlazarse con una tabla y el identificador
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        // actualizar el boolean de la celda cuando se cargue
        let item =  arrayName[indexPath.row]
        cell.accessoryType = item.check ? .checkmark : .none
        // agregar el label
        cell.textLabel?.text = self.arrayName[indexPath.row].title
        // retornar el cell
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Ejemplo de como cambiar variables del item
        //arrayName[indexPath.row].setValue("completed", forKey: "title")
        
        // Eliminar el item de la lista
        //context.delete(arrayName[indexPath.row])  // Elimina del contexto
        //arrayName.remove(at: indexPath.row) // elimina de la lista actual
        
        
        // actualizar el valor bool de la lista
        //arrayName[indexPath.row].check = !arrayName[indexPath.row].check
        
        saveItems()
        
        // actualizar la lista
        tableView.reloadData()
        // mostrar un flash para saber cual seleccionamos
        tableView.deselectRow(at: indexPath, animated: true)
       
        
        
        
        //--------------------- Solucion 1: con bugs
        // Marca de verificacion, checkbox si ya tiene o no check
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
    }
    
    //MARK: - Add new Items
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
            
            let item = Item(context: self.context)
            item.check = false
            item.title = textField.text!
            item.parentCategory = self.selectedCategory
            
            self.arrayName.append(item)
            /* // guardar en el contendor de la app la lista
            self.defaults.set(self.arrayName, forKey: "TodoListArray")
            self.tableView.reloadData()
            */
            self.saveItems()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model manipulation methods
    func saveItems(){
        do {
            try context.save()
        } catch  {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    // Recuperar la tabla Items del CoreData se realiza el FetchRequest
    // Se envia por parametro la peticion con la que desea consultar y si envia null, se usa el item.fetchRequest por defecto.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        do {
                // predicate es para hacer condicionales
               let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@ ", selectedCategory!.name!)
            
                if let addPredicate = predicate {
                    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addPredicate])
                } else {
                    request.predicate = categoryPredicate
                }
            
                arrayName = try context.fetch(request)
            
            } catch {
                print("error fetching database \(error)")
            }
            tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension ListViewController: UISearchBarDelegate{
//    Notifica al delegado que el boton de buscar fue presionado
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("busqueda")
        print("busqueda \(searchBar.text!) " )
        // crear la peticionxº
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // agregar un predicate para poder filtrar
        let newPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // organizar los elementos buscados por orden del titulo
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // solicitar al cargar datos actualizar la tabla con el request creado
        // se hace uso del parametro externo, para que tenga sentido al lerr.
        loadItems(with: request, predicate: newPredicate)
        
    }
    // Metodo delegado que se ejecuta cuando el texto cambia
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // carga nuevament todos los items, es por eso que no se envia un request
            loadItems()
            // Función para hacer que el hilo principal ejecute el código contenido
            // DispatchQueue, gestiona la ejecución de los elementos de trabajo
            // Podemos ingresar a ese hilo principal y agregar codigo para que se ejecute
            DispatchQueue.main.async {
                // oculata el teclado de textoy lo deja en la forma original.
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

