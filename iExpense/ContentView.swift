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
   
   var personalExpenses : [ExpenseItem] {
      expenses.items.filter { item in
         item.type == "Personal"
      }
   }
   
   var businessExpenses : [ExpenseItem] {
      expenses.items.filter { item in
         item.type == "Business"
      }
   }
   
   
    var body: some View {
       
       NavigationView {
          List {
             Section {
                ForEach(personalExpenses) { item in
                   HStack {
                      VStack(alignment: .leading) {
                         Text(item.name)
                            .font(.headline)
                         Text(item.type)
                      }
                      
                      Spacer()
                      Text(item.amount, format: .currency(code: currencyCode))
                         .extraStyling(for: item.amount)
                   }
                }
                .onDelete(perform: deleteItem(for: "Personal"))
             } header: {
                Text("Personal")
             }
             
             Section {
                ForEach(businessExpenses) { item in
                   HStack {
                      VStack(alignment: .leading) {
                         Text(item.name)
                            .font(.headline)
                         Text(item.type)
                      }
                      
                      Spacer()
                      Text(item.amount, format: .currency(code: currencyCode))
                         .extraStyling(for: item.amount)
                   }
                }
                .onDelete(perform: deleteItem(for: "Business"))
             } header : {
                Text("Business")
             }
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
   
   
   func deleteItem(for category: String) -> (_ offsets: IndexSet) -> Void {
      
      //Create an inner function to return
      func removeItem(offsets: IndexSet) {
         if let index = offsets.first {
            
            //Based on the passed category string, point to the proper calculated property
            let elements : [ExpenseItem]
            if category == "Personal" {
               elements = personalExpenses
            }
            else {
               elements = businessExpenses
            }
            
            //Now use a common method to find and delete the element from the overall array
            let element = elements[index]
            if let expenseIndex = expenses.items.firstIndex(where: {$0.id == element.id}) {
               expenses.items.remove(at: expenseIndex)
            }
         }
      }
      
      return removeItem
      
   }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
