//
//  Category.swift
//  Books
//
//  Created by 村尾慶伸 on 2020/04/02.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic var authorName = ""
    @objc dynamic var title = ""
    @objc dynamic var date = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var id = ""
    @objc dynamic var rating: Int = 0
    @objc dynamic var impression: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
