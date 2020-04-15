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
    var dateTextField = UITextField()
    var datePicker = UIDatePicker()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        if let book = books?[indexPath.row] {
            
            cell.titleLabel?.text = book.title
            cell.authorLabel?.text = book.authorName
            cell.dateLabel?.text = book.date

        }
    
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action =  UIContextualAction(style: .destructive, title: nil, handler: { (_, _, completionHandler ) in

            self.delete(at: indexPath)
            self.table.reloadData()
            completionHandler(true)
        })

        action.image = UIImage(named: "delete-icon")
        action.backgroundColor = .red
        let configulation = UISwipeActionsConfiguration(actions: [action])

        return configulation

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
    
    func delete(at IndexPath: IndexPath) {
        
        if let bookForDeletion = self.books?[IndexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(bookForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }

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
                || (self.authorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
                || (self.dateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!)
            {
                
                self.titleTextField.text = ""
                self.authorTextField.text = ""
                self.dateTextField.text = ""
                
                self.displayAddField(message: "タイトル、作家、日付を入力してください。")
                
                return

            }
            

            newBook.title = self.titleTextField.text!
            newBook.authorName = self.authorTextField.text!
            newBook.date = self.dateTextField.text!

            
            self.save(book: newBook)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "タイトルを入力"
            alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 20))
            self.titleTextField = alertTextField
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "作家を入力"
            alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 20))
            self.authorTextField = alertTextField

        }
        
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 20))
            self.dateTextField = alertTextField
            self.dateTextField.placeholder = "日付を選択"
            self.datePicker.datePickerMode = UIDatePicker.Mode.date
            self.datePicker.timeZone = NSTimeZone.local
            self.datePicker.locale = Locale.current
            self.dateTextField.inputView = self.datePicker
            self.setupToolbar()
            
        }

        
        alert.addAction(action)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
        
        
    }
    
    func setupToolbar() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 42))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([cancelItem, spaceButton,doneItem], animated: true)
        dateTextField.inputAccessoryView = toolbar

    }
    
    @objc func done() {
        
        dateTextField.endEditing(true)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"

    }
    
    @objc func cancel() {
        dateTextField.endEditing(true)
    }
    
    
    @IBAction func addBook(_ sender: UIBarButtonItem) {

        displayAddField(message: "読んだ本を登録")

    }
    

}

