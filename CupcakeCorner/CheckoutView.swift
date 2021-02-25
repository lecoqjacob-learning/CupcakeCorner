//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Jacob LeCoq on 2/23/21.
//

import SwiftUI

struct CheckoutView: View {
    @State var orderWrapper: OrderWrapper
    
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var showingAlert = false

    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(orderWrapper.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.alertTitle = "Error Ordering"
                self.alertMsg = "Error ordering your goodness :("
                self.showingAlert = true
                
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertTitle = "Thank You!"
                self.alertMsg = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            } else {
                self.alertMsg = "Error ordering your goodness :("
                print("Invalid response from server")
            }
            
            self.showingAlert = true
            
        }.resume()
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)

                    Text("Your total is $\(self.orderWrapper.order.cost, specifier: "%.2f")")
                        .font(.title)

                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orderWrapper: OrderWrapper())
    }
}
