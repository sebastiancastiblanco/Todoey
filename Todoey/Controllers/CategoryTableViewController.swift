//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Sebastián Castiblanco on 7/08/18.
//  Copyright © 2018 Sebastián Castiblanco. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    // Crear lista de categorias
    var categoryList = [Category]()
    // Contexto para poder usar el CoreData
    // Contexto para usar CoreData y para poder salvar datos y persistirlos
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // cargar las cateogiras previamente ya creadas
        loadCategories()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categotyList", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categoryList[indexPath.row].name

        return cell
    }
    
    //MARK: - TAble view delegate methods
    // Metodo cuando selecciona un elemento
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // redireccionar a la pagina de items, usando segue
        performSegue(withIdentifier: "TogoItems", sender: self)
        // ya que se debe enviar la categoria seleccionada, se usa el prepare
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cvList = segue.destination as! ListViewController
        
        if  let indexCategory = tableView.indexPathForSelectedRow {
            cvList.selectedCategory = categoryList[indexCategory.row]
        }
        
    }
    
    //MARK: - Model manipulation methods
    func saveCategory(){
        do {
            try context.save()
        } catch  {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    // Load data from coredata
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("error fetching database \(error)")
        }
        tableView.reloadData()
    }
    
    // Metodo para agregar una categoria
    @IBAction func AddCategory(_ sender: UIBarButtonItem) {
        var inputTextUse = UITextField()
        // se debe Crear el AlertController
        let alert = UIAlertController(title: "Add Category", message: "type the new Category", preferredStyle: .alert)
        
        // crear la accion para el alert controller
        
       let action = UIAlertAction(title: "Add Catagory", style: .default) { (action) in
        
            NSLog("The \"OK\" alert occured.")
            // recuperar la data del UITextField
            // se crea una categoria con el contexto de Core Data
            let newCategory =  Category(context: self.context)
            newCategory.name = inputTextUse.text!
            
            // Agregar a la lista la nueva categoria.
            self.categoryList.append(newCategory)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Nueva categoria"
            inputTextUse = textfield
        }
        
        // craer el input y agregarlo al alert
        // agregar la accion a la alerta
        alert.addAction(action)
        
        // mostrar el alertcontroller
        self.present(alert, animated: true, completion: nil)
    }
    
}
