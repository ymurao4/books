//
//  ItemViewController.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/27.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit
import RealmSwift
import Cosmos

class ItemViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var titleTextField = UITextField()
    private var authorTextField = UITextField()
    private var dateTextField = UITextField()
    private var datePicker = UIDatePicker()
    
    var delegate: ViewController?
    
    var selectedBook: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        // edit button
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(editButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedBook?.title
        dateLabel.text = selectedBook?.date
        titleLabel.text = selectedBook?.title
        authorLabel.text = selectedBook?.authorName
        
//         cosmos
        cosmosView.settings.starSize = 20
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.filledColor = UIColor(red: 255 / 255, green: 193 / 255, blue: 77 / 255, alpha: 0.7)
        if let rating = selectedBook?.rating {
            cosmosView.rating = rating
        }
        
        dateLabel.adjustsFontSizeToFitWidth = true
        
        stackView.decorationStackView()

    }

    
//    @objc func editButtonTapped() {
//        delegate?.displayAddField(message: "編集する")
//    }
    
    
    
    //編集
    
//    func displayEditField(message: String) {
//
//        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
//
//        let cancel = UIAlertAction(title: "取り消し", style: .destructive, handler: nil)
//
//        let action = UIAlertAction(title: "完了", style: .default) { (action) in
//
//            let book = Book()
//            if let id = self.selectedBook?.id {
//                book.id = id
//            }
//
//
//
//
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = self.selectedBook?.title
//            self.titleTextField = alertTextField
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = self.selectedBook?.authorName
//            self.authorTextField = alertTextField
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.addConstraint(alertTextField.heightAnchor.constraint(equalToConstant: 20))
//            alertTextField.delegate = self
//            self.dateTextField = alertTextField
//            self.dateTextField.placeholder = "日付を選択"
//            self.datePicker.datePickerMode = UIDatePicker.Mode.date
//            self.datePicker.timeZone = NSTimeZone.local
//            self.datePicker.locale = Locale.current
//            self.dateTextField.inputView = self.datePicker
//            self.setupToolbar()
//        }
//
//        alert.addAction(cancel)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//
//    }
//
//    func setupToolbar() {
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 42))
//        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//        toolbar.setItems([cancelItem, spaceButton,doneItem], animated: true)
//        dateTextField.inputAccessoryView = toolbar
//    }
//
//    @objc func done() {
//
//        dateTextField.endEditing(true)
//
//        let formatter = DateFormatter()
//
//        formatter.dateFormat = "yyyy/MM/dd"
//        dateTextField.text = "\(formatter.string(from: datePicker.date))"
//
//    }
//
//    @objc func cancel() {
//        dateTextField.endEditing(true)
//    }


}


// custom stackview
extension UIStackView {
    func decorationStackView() {
        let subview = UIView(frame: bounds)
        subview.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        subview.layer.borderWidth = 1
        subview.layer.borderColor = UIColor.systemGray.cgColor
        subview.backgroundColor = UIColor.systemGray
        subview.alpha = 0.2
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}
