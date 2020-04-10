//
//  CategoryViewController.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/02.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    
    
    let realm = try! Realm()
    
    var books: Results<Book>?
    
    var titleTextField = UITextField()
    var authorTextField = UITextField()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let book = books?[indexPath.row] {
            
            cell.textLabel?.text = book.title
            cell.detailTextLabel?.text = book.authorName


        }
    
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(book: Book) {

        do {
            try realm.write {
                realm.add(book)
            }
        } catch {
            print("Error saving book \(error)")
        }
        
        table.reloadData()
        
    }
    
    func loadCategories() {

        books = realm.objects(Book.self)
        
        table.reloadData()

    }
    
    func displayAddField(message: String) {
        
        // Create alert
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        // Create cancel button
        let cancel = UIAlertAction(title: "取り消し", style: .cancel, handler: nil)
        
        // Create saveButton
        let action = UIAlertAction(title: "登録", style: .default) { (action) in
            
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            let newBook = Book()
            

            // validation
            if ((self.titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                || (self.authorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!)
            {
                
                self.titleTextField.text = ""
                self.authorTextField.text = ""
                
                self.displayAddField(message: "タイトル、作家を入力してください。")
                
                return

            }
            

            newBook.title = self.titleTextField.text!
            newBook.authorName = self.authorTextField.text!

            
            self.save(book: newBook)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "タイトルを入力"
            self.titleTextField = alertTextField
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "作家を入力"
            self.authorTextField = alertTextField

        }
        
        
        alert.addAction(action)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func addBook(_ sender: UIBarButtonItem) {

        displayAddField(message: "読んだ本を登録")

    }
    

}

