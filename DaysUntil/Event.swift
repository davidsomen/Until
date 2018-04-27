//
//  Event.swift
//  DaysUntil
//
//  Created by David Somen on 2018/04/06.
//  Copyright © 2018 David Somen. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object
{
    @objc dynamic var title = ""
    @objc dynamic var date = Date()
    @objc dynamic var isDeleted = false
}
