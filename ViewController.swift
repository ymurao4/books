//
//  CategoryViewController.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/02.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit
import RealmSwift
import Cosmos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.starSize = 30
        view.settings.fillMode = .full
        view.settings.updateOnTouch = true
        view.settings.filledColor = UIColor(red: 255 / 255, green: 193 / 255, blue: 77 / 255, alpha: 0.7)
        
        return view
    }()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var authorButton: UIButton!
    
    let realm = try! Realm()
    
    var books: Results<Book>?
    
    private var dateFlag: Bool = false
    private var titleFlag: Bool = false
    private var authorFlag: Bool = false
    
    private var titleTextField = UITextField()
    private var authorTextField = UITextField()
    private var dateTextField = UITextField()
    private var datePicker = UIDatePicker()
    private var impressionTextField = UITextField()
    
    // change color weather ios 13
    let dynamicColor = UIColor{ (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark{
            return UIColor(red: 29 / 255, green: 161 / 255, blue: 242 / 255, alpha: 1)
        } else {
            return UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        }
    }
    
    let dynamicTintColor = UIColor{ (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark{
            return UIColor.black
        } else {
            return UIColor.white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadItems(sortText: "date", flag: false)

    }

    override func viewDidLayoutSubviews() {
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = dynamicColor.cgColor
        titleButton.addBorder(width: 1, color: dynamicColor, position: .top)
        titleButton.addBorder(width: 1, color: dynamicColor, position: .bottom)
        authorButton.layer.borderWidth = 1
        authorButton.layer.borderColor = dynamicColor.cgColor
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedBook = books?[indexPath.row]
        }
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
        
        // segue
        performSegue(withIdentifier: "goToItems", sender: self)
        return tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action =  UIContextualAction(style: .destructive, title: nil, handler: { (_, _, completionHandler ) in

            self.delete(at: indexPath)
            self.tableView.reloadData()
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
        
        tableView.reloadData()
        
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
            newBook.rating = self.cosmosView.rating
            
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

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "感想・メモなど"
            self.impressionTextField = alertTextField
        }
        
        // rating
        alert.addTextField { (alertTextField) in
            alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 30))
            alertTextField.addSubview(self.cosmosView)
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
    
    
    func loadItems(sortText: String, flag: Bool) {

        books = realm.objects(Book.self).sorted(byKeyPath: sortText, ascending: flag)
        
        tableView.reloadData()

    }
    

    //MARK: - Search Methods
    func filterKeyword(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            books = books?.filter("title CONTAINS[cd] %@ OR authorName CONTAINS[cd] %@", text, text).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
        }
        
    }
    
    
    func cancelSearchBar(_ sesarchBar: UISearchBar) {
        
        loadItems(sortText: "date", flag: false)
        
    }

    // Switch sortBar color, when sortBar clicked.
    func switchSortButtonColor(_ button: UIButton) {
        
        switch button.tag {
        case 0:
            if dateButton.backgroundColor == dynamicColor {
                dateButton.backgroundColor = dynamicTintColor
                dateButton.tintColor = dynamicColor
                dateFlag = false
                loadItems(sortText: "date", flag: dateFlag)
            } else {
                dateButton.backgroundColor = dynamicColor
                dateButton.tintColor = dynamicTintColor
                titleButton.backgroundColor = dynamicTintColor
                titleButton.tintColor = dynamicColor
                authorButton.backgroundColor = dynamicTintColor
                authorButton.tintColor = dynamicColor
                dateFlag = true
                loadItems(sortText: "date", flag: dateFlag)
            }
        case 1:
            if titleButton.backgroundColor == dynamicColor {
                titleButton.backgroundColor = dynamicTintColor
                titleButton.tintColor = dynamicColor
                titleFlag = false
                loadItems(sortText: "title", flag: titleFlag)
            } else {
                dateButton.backgroundColor = dynamicTintColor
                dateButton.tintColor = dynamicColor
                titleButton.backgroundColor = dynamicColor
                titleButton.tintColor = dynamicTintColor
                authorButton.backgroundColor = dynamicTintColor
                authorButton.tintColor = dynamicColor
                titleFlag = true
                loadItems(sortText: "title", flag: titleFlag)
            }
            
        case 2:
            if authorButton.backgroundColor == dynamicColor {
                authorButton.backgroundColor = dynamicTintColor
                authorButton.tintColor = dynamicColor
                authorFlag = false
                loadItems(sortText: "authorName", flag: authorFlag)
            } else {
                dateButton.backgroundColor = dynamicTintColor
                dateButton.tintColor = dynamicColor
                titleButton.backgroundColor = dynamicTintColor
                titleButton.tintColor = dynamicColor
                authorButton.backgroundColor = dynamicColor
                authorButton.tintColor = dynamicTintColor
                authorFlag = true
                loadItems(sortText: "authorName", flag: authorFlag)
            }
        default:
            print("error")
        }

    }
    
    
    // MARK: - Sort Methods
    
    @IBAction func pressDateButton(_ sender: Any) {
        switchSortButtonColor(dateButton)
    }
    
    @IBAction func pressTitleButton(_ sender: Any) {
        switchSortButtonColor(titleButton)
    }
    
    @IBAction func pressAuthorButton(_ sender: Any) {
        switchSortButtonColor(authorButton)
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




