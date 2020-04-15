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
}
