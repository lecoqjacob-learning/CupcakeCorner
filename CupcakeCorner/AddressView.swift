//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Jacob LeCoq on 2/23/21.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var orderWrapper: OrderWrapper

    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderWrapper.order.name)
                TextField("Street Address", text: $orderWrapper.order.streetAddress)
                TextField("City", text: $orderWrapper.order.city)
                TextField("Zip", text: $orderWrapper.order.zip)
            }

            Section {
                NavigationLink(destination: CheckoutView(orderWrapper: orderWrapper)) {
                    Text("Check out")
                }
            }
            .disabled(orderWrapper.order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView(orderWrapper: OrderWrapper())
        }
    }
}
