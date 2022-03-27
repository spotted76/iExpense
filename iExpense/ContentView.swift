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
                .onDelete(perform: removePersonal(at:))
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
                .onDelete(perform: removeBusiness(at:))
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
   
   func removeItem(at offsets: IndexSet) {
      expenses.items.remove(atOffsets: offsets)
   }
   
   func removePersonal(at offsets: IndexSet) {
      if let personalIndex = offsets.first {
         let personalElement = personalExpenses[personalIndex]
         if let expenseIndex = expenses.items.firstIndex(where: {$0.id == personalElement.id}) {
            expenses.items.remove(at: expenseIndex)
         }
      }
   }
   
   func removeBusiness(at offsets: IndexSet) {
      if let buisinessIndex = offsets.first {
         let businessElement = businessExpenses[buisinessIndex]
         if let expenseIndex = expenses.items.firstIndex(where: {$0.id == businessElement.id}) {
            expenses.items.remove(at: expenseIndex)
         }
      }
   }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
