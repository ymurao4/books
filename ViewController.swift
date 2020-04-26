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
    
    @IBOutlet weak var dateButtonLabel: UIButton!
    @IBOutlet weak var titleButtonLabel: UIButton!
    @IBOutlet weak var authorButtonLabel: UIButton!
    
    let realm = try! Realm()
    
    var books: Results<Book>?
    
    private var flag: Bool = false
    
    private var titleTextField = UITextField()
    private var authorTextField = UITextField()
    private var dateTextField = UITextField()
    private var datePicker = UIDatePicker()
    
    private let borderColor:UIColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        loadItems(sortText: "date")

    }

    override func viewDidLayoutSubviews() {
        dateButtonLabel.layer.borderWidth = 1
        dateButtonLabel.layer.borderColor = borderColor.cgColor
        titleButtonLabel.addBorder(width: 1, color: borderColor, position: .top)
        titleButtonLabel.addBorder(width: 1, color: borderColor, position: .bottom)
        authorButtonLabel.layer.borderWidth = 1
        authorButtonLabel.layer.borderColor = borderColor.cgColor
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
        return tableView.deselectRow(at: indexPath, animated: true)
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
    
    func updateModel(book: Book) {
        
        try! realm.write {
            
            realm.add(book, update: .modified)
        }

    }
    
    func delete(at IndexPath: IndexPath) {
        
        if let books = self.books?[IndexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(books)
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
                
                self.displayAddField(message: "タイトル、著者、日付を入力してください。")
                
                return

            }
            

            newBook.title = self.titleTextField.text!
            newBook.authorName = self.authorTextField.text!
            newBook.date = self.dateTextField.text!
            newBook.dateCreated = Date()
            newBook.id = NSUUID().uuidString
            
            self.save(book: newBook)

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "タイトルを入力"
            alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 20))
            self.titleTextField = alertTextField
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "著者を入力"
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
    
    
    func loadItems(sortText: String) {

        books = realm.objects(Book.self).sorted(byKeyPath: sortText, ascending: flag)
        
        table.reloadData()

    }
    

    //MARK: - Search Methods
    func filterKeyword(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            books = books?.filter("title CONTAINS[cd] %@ OR authorName CONTAINS[cd] %@", text, text).sorted(byKeyPath: "date", ascending: false)
            table.reloadData()
        }
        
    }
    
    
    func cancelSearchBar(_ sesarchBar: UISearchBar) {
        
        loadItems(sortText: "date")
        
    }
    
    func switchFlag(_ f: Bool) {
        flag = f ? false : true
    }
    
    
    // MARK: - Sort Methods
    
    @IBAction func pressDateButton(_ sender: Any) {
        switchFlag(flag)
        loadItems(sortText: "date")
    }
    
    @IBAction func pressTitleButton(_ sender: Any) {
        switchFlag(flag)
        loadItems(sortText: "title")
    }
    
    @IBAction func pressAuthorButton(_ sender: Any) {
        switchFlag(flag)
        loadItems(sortText: "authorName")
    }
    
}



// MARK: - set borders

enum BorderPosition {
    case top
    case left
    case right
    case bottom
}

extension UIView {
    
    func addBorder(width: CGFloat, color: UIColor, position: BorderPosition) {
        
        let border = CALayer()
        
        switch position {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .right:
            border.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
            border.backgroundColor = color.cgColor
            self.layer.addSublayer(border)
        }

    }

}
