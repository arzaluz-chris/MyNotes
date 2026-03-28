//
//  NoteStore.swift
//  MyNotes
//
//  Created by Christian Arzaluz on 28/03/26.
//

import Foundation

class NoteStore {
    private(set) var notes: [Note] = []

    var count: Int { notes.count }

    func add(_ note: Note) {
        notes.insert(note, at: 0)
    }

    func update(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        }
    }

    func delete(at index: Int) {
        notes.remove(at: index)
    }

    func note(at index: Int) -> Note {
        notes[index]
    }
}
