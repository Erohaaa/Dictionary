//
//  WordsData.swift
//  Dictionary
//
//  Created by Виталя on 21.11.2022.
//
import CoreData

public class Word: NSManagedObject {
    @NSManaged var english: String
    @NSManaged var ukrainian: String
    @NSManaged var timestamp: Date
    @NSManaged var inRepetition: Bool
}

