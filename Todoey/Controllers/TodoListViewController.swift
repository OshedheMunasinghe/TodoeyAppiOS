//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]() //List of objects of Items
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      //  loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count //creating 3 cells in table view
    }
    
    //MARK: - Tableview Datasourse Methods
    //cells of row at indexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operatör ==>
        //value = condition ? valueTrue : ValueFalse
        cell.accessoryType = item.done ? .checkmark : .none
    
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    //When user click on one cell...
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //when user pressed add button it should come up alert pop up message
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //Button to Add Item in pop up message
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Sucess!")
            //when user has write on the textField and pressed Add
            
          
            
            // print(textField.text) //this will return Optional.. so we need to wrap!
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.tableView.reloadData() // to refresh the tabel otherwise you won't see your new lable
            
            self.saveItems()
        }
        
        //When user write in the text in pop up message
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
       
        
        do{
           
            try context.save()
        }catch{
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }//end saveItems
 
    /*
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }//end loadItems
 */
    
}

