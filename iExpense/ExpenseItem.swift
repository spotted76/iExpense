//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Peter Fischer on 3/26/22.
//

import Foundation

struct ExpenseItem : Identifiable, Codable {
   var id = UUID()
   let name: String
   let type: String
   let amount: Double
}
