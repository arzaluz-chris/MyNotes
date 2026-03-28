//
//  Note.swift
//  MyNotes
//
//  Created by Christian Arzaluz on 28/03/26.
//

import Foundation

struct Note {
    let id: UUID
    var title: String
    var content: String
    var date: Date

    init(id: UUID = UUID(), title: String, content: String, date: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.date = date
    }
}
