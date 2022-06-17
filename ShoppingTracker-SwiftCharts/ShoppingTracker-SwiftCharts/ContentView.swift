//
//  ContentView.swift
//  ShoppingTracker-SwiftCharts
//
//  Created by Viennarz Curtiz on 6/16/22.
//

import SwiftUI
import Charts


func date(year: Int, month: Int, day: Int = 1) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
}

struct ContentView: View {
    @State private var isFormViewShown: Bool = false
    @State private var purchaseByCategorySectionValue = 1
    
    @State var products: [PurchaseItem] = [
        .init(name: "Apple Watch", numberOfItems: 1, price: 18000, category: .electronics, dateOfPurchase: Date(timeIntervalSinceNow: -86400)),
        .init(name: "Uniqlo Pants", numberOfItems: 2, price: 1500, category: .clothing, dateOfPurchase: date(year: 2022, month: 1, day: 15)),
        .init(name: "Burger", numberOfItems: 3, price: 18000, category: .food, dateOfPurchase: date(year: 2022, month: 4, day: 10)),
        .init(name: "Apple M1 MacBook Pro", numberOfItems: 1, price: 72000, category: .electronics, dateOfPurchase: date(year: 2022, month: 4, day: 1)),
        .init(name: "Samsung TV", numberOfItems: 1, price: 14000, category: .appliance, dateOfPurchase: date(year: 2022, month: 2, day: 21)),
    ]
    
    func getTotalPurchaseAmount() -> Double {
        let prices = products.map { $0.price }
        let total = prices.reduce(.zero, +)
        
        return total
    }
    
    func getMonthWithMostNumberOfPurchases() -> String {
        
        let highest = products.max(by: { (item, item2) -> Bool in
            return item.numberOfItems < item2.numberOfItems
            
        })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        
        if let item = highest {
            let monthString = dateFormatter.string(from: item.dateOfPurchase)
            return monthString
            
        }

        return "None"
            
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    VStack {
                        HStack {
                            Text("Total expenses you made is \u{20B1}\(getTotalPurchaseAmount(), specifier: "%.2f")")
                                .font(.headline)
                            Spacer()
                        }
                        
                        Chart(products) { item in
                            BarMark(
                                x: .value("Price", item.price),
                                y: .value("Name", item.name)
                                
                            ).foregroundStyle(by: .value("Category", item.category.title))
                            
                        }
                        .chartForegroundStyleScale(range: Gradient(colors: [.pink,.purple]))
                        .frame(height: 300)
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGroupedBackground)))

                    
                    
                    VStack(spacing: 8) {
                        VStack {
                            HStack {
                                Text("Most Purchases is on \(getMonthWithMostNumberOfPurchases())")
                                    .font(.headline)
                                Spacer()
                            }
                            
                            HStack {
                                Text("Purchases on each month ")
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                        
                        
                        Chart(products) { item in
                            BarMark(
                                x: .value("Date", item.dateOfPurchase, unit: .month),
                                y: .value("Price", item.numberOfItems))
                                
                        }
                            
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGroupedBackground)))
                    .frame(height: 200)
                    
                    
                    VStack {
                        HStack {
                            Text("Purchases by Category")
                                .font(.headline)
                            Spacer()

                        }
                        
                        
                        Picker("Purchases by Category", selection: $purchaseByCategorySectionValue.animation(.easeInOut)) {
                            Text("Item Count")
                                .tag(1)
                            Text("Price")
                                .tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        Chart(products) { item in
                            BarMark(
                                x: .value("Category", purchaseByCategorySectionValue == 1 ? Double(item.numberOfItems) : item.price))
                            .foregroundStyle(by: .value("Category", item.category.title))
                            
                        }
                        .chartXAxis(.hidden)
                        .chartForegroundStyleScale(range: Gradient(colors: [.green,.yellow]))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGroupedBackground)))
                    .frame(height: 150)
                }
                .padding(16)
                .toolbar {
                    ToolbarItem(id: "1") {
                        Button {
                            isFormViewShown = true
                        } label: {
                            Text("Add Purchase")
                        }

                    }
                }
            }
        }
        .sheet(isPresented: $isFormViewShown) {
            FormView(onTapSave: { product in
                products.append(product)
                isFormViewShown = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
