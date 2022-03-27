//
//  ContentView.swift
//  iExpense
//
//  Created by Peter Fischer on 3/24/22.
//

import SwiftUI

//Helps with extra styling
extension Text {
      
   func extraStyling(for value: Double) -> Text {
      if value > 100.0 {
         return self.foregroundColor(.green).bold()
      }
      else if value > 10.0 {
         return self.foregroundColor(.blue).italic()
      }
      else {
         return self
      }
   }
}


struct ContentView: View {

   @StateObject var expenses = Expenses()
   @State private var showingAddExpense = false
   
   let currencyCode = Locale.current.currencyCode ?? "USD"
   
    var body: some View {
       
       NavigationView {
          List {
             ForEach(expenses.items) { item in
                HStack {
                   VStack(alignment: .leading) {
                      Text(item.name)
                         .font(.headline)
                      Text(item.type)
                   }
                   
                   Spacer()
                   Text(item.amount, format: .currency(code: currencyCode))
                      .extraStyling(for: item.amount)
//                   CurrencyView(value: item.amount)
                }
             }
             .onDelete(perform: removeItem(at:))
          }
          .navigationTitle("iExpense")
          .toolbar {
             Button {
                showingAddExpense = true
             } label: {
                Image(systemName: "plus")
             }
          }
       }
       .sheet(isPresented: $showingAddExpense) {
          AddView(expenses: expenses)
       }
       
    }
   
   func removeItem(at offsets: IndexSet) {
      expenses.items.remove(atOffsets: offsets)
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
