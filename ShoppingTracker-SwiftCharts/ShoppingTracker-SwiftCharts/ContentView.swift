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
    @State private var purchaseCountDateRange = Calendar.Component.month
    
    
    //Initial data
    @State var products: [PurchaseItem] = [
        .init(name: "Apple Watch", numberOfItems: 1, price: 18000, category: .electronics, dateOfPurchase: Date(timeIntervalSinceNow: -86400)),
        .init(name: "Uniqlo Pants", numberOfItems: 2, price: 1500, category: .clothing, dateOfPurchase: date(year: 2022, month: 1, day: 15)),
        .init(name: "Burger", numberOfItems: 3, price: 18000, category: .food, dateOfPurchase: date(year: 2022, month: 4, day: 10)),
        .init(name: "Apple M1 MacBook Pro", numberOfItems: 1, price: 72000, category: .electronics, dateOfPurchase: date(year: 2022, month: 4, day: 1)),
        .init(name: "Samsung TV", numberOfItems: 1, price: 14000, category: .appliance, dateOfPurchase: date(year: 2022, month: 2, day: 21)),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    
                    buildTotalExpenseChartContainer()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))

                    
                    buildPurchasesContainer()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                        .frame(height: 250)
                    
                    buildPurchasesCategoryChartContainer()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
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
            .background(Color(.systemBackground))
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

//MARK: - Containers
extension ContentView {
    private func buildTotalExpenseChartContainer() -> some View {
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
    }
    
    private func buildPurchasesContainer() -> some View {
        VStack(spacing: 8) {
            VStack {
                HStack {
                    Text("Most Purchases is on \(getMonthWithMostNumberOfPurchases())")
                        .font(.headline)
                    Spacer()
                }
                
                HStack {
                    Text("Purchases by \(getDatePeriodText(from: purchaseCountDateRange)) ")
                        .font(.subheadline)
                    Spacer()
                }
            }
            
            Picker("Date Range", selection: $purchaseCountDateRange.animation(.easeInOut)) {
                Text("Year")
                    .tag(Calendar.Component.year)
                Text("Quarter")
                    .tag(Calendar.Component.quarter)
                Text("Month")
                    .tag(Calendar.Component.month)
                Text("Weekday")
                    .tag(Calendar.Component.weekday)
            }
            .pickerStyle(.segmented)
            
            Chart(products) { item in
                BarMark(
                    x: .value("Date", item.dateOfPurchase, unit: purchaseCountDateRange),
                    y: .value("Price", item.numberOfItems))
                    
            }
                
            
        }
    }
    
    private func buildPurchasesCategoryChartContainer() -> some View {
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
    }
}


//MARK: - Helpers
extension ContentView {
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
    
    func getDatePeriodText(from components: Calendar.Component) -> String {
        switch components {
            
        case .era:
            return "Era"
        case .year:
            return "Year"
        case .month:
            return "Month"
        case .day:
            return "Day"
        case .hour:
            return "Hour"
        case .minute:
            return "Minue"
        case .second:
            return "Second"
        case .weekday:
            return "Weekday"
        case .weekdayOrdinal:
            return "Week Day Ordinal"
        case .quarter:
            return "Quarter"
        case .weekOfMonth:
            return "Week of Month"
        case .weekOfYear:
            return "Week of Year"
        case .yearForWeekOfYear:
            return "Year for Week of Year"
        case .nanosecond:
            return "Nanosecond"
        case .calendar:
            return "Calendar"
        case .timeZone:
            return "Time Zone"
        @unknown default:
            return ""
        }
    }
}
