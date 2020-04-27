//
//  ItemViewController.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/27.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var impressionLabel: UILabel!
    
    var selectedBook: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedBook?.title
        
        dateLabel.text = selectedBook?.date
        titleLabel.text = selectedBook?.title
        authorLabel.text = selectedBook?.authorName
        
    }

}
