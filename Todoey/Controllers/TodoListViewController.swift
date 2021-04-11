//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Items]() //List of objects of Items
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let newItem = Items()
        newItem.title = "French Bulldog"
        itemArray.append(newItem)
        
        let newItem1 = Items()
        newItem1.title = "Pug"
        itemArray.append(newItem1)
        
        let newItem2 = Items()
        newItem2.title = "English Bulldog"
        itemArray.append(newItem2)
        
        
         if let items = defaults.array(forKey: "TodoListArray") as? [Items]{
             itemArray = items
        }
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
        
        /*  if item.done == true{
         cell.accessoryType = .checkmark
         }else{
         cell.accessoryType = .none
         }
         */
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    //When user click on one cell...
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
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
            let newItem = Items()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //store data when app is terminate
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            self.tableView.reloadData() // to refresh the tabel otherwise you won't see your new lable
        }
        
        //When user write in the text in pop up message
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

