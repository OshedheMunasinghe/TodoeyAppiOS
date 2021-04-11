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
        
        //to find the file where the db files or plist is....
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       // searchBar.delegate = self
        
       loadItems()
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
        
      
        // DELETE
        //If you don't delete first from CoreData it will come up bug! out of range
        //check video 255
     //   context.delete(itemArray[indexPath.row]) //this delete in DataCore! otherwise old data will be saved!
        
    //    itemArray.remove(at: indexPath.row) //this doesnt do with DataCore, it just "view" phone
      
        //this makes checkmarks... which it has a bug..
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
 
    //Item.fetch... is a default value that's how loadItems works in viewLoad()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
    //    let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
           itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }//end loadItems
}//end TodoLostViewController

//MARK: - SearchBar
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest() //read data
        
        //we need to get which query to fetch the row
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sort the data that we get back from the database in any order of our choice
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }//end searchBarSearchButtonClicked
    
}//end extension:UISearchBarDelegate

