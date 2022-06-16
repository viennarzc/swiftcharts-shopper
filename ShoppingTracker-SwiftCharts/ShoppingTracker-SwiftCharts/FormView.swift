//
//  FormView.swift
//  ShoppingTracker-SwiftCharts
//
//  Created by Viennarz Curtiz on 6/16/22.
//

import SwiftUI
import Charts

enum Category: Int, CaseIterable, Identifiable {
    var id: String { title }
    
    case food = 0
    case electronics = 1
    case appliance = 2
    case clothing = 3
    case other = 4
    
    var title: String {
        switch self {
        case .clothing: return "Clothing"
        case .appliance: return "Appliance"
        case .electronics: return "Electronics"
        case .food: return "Food"
        case .other: return "Other"
        }
    }
}

struct FormView: View {
    @State private var productName: String = ""
    @State private var numberOfItems: Int = 1
    @State private var dateOfPurchase: Date = Date()
    @State private var category: Category = .other
    @State private var price: Double = 0.0
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "PHP"
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }
    
    var onTapSave: (PurchaseItem) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Product Name", text: $productName)
                    
                    Stepper("Number of Items: \(numberOfItems)", value: $numberOfItems, in: 1...20)
        
                    Picker("Cateogory", selection: $category) {
                        ForEach(Category.allCases) { category in
                            Text(category.title)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    TextField("Price", value: $price, formatter: numberFormatter)
                        .keyboardType(.numberPad)
                }
                

            }
            .navigationTitle("Add Purchase")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onTapSave(
                            PurchaseItem(
                                name: productName,
                                numberOfItems: numberOfItems,
                                price: price,
                                category: category, dateOfPurchase: Date())
                        )
                        
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.bordered)
                    .disabled(productName.isEmpty)

                }
            }
            
            
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(onTapSave: { _ in})
    }
}


struct PurchaseItem: Identifiable {
    let id = UUID()
    let name: String
    let numberOfItems: Int
    let price: Double
    let category: Category
    let dateOfPurchase: Date
}
