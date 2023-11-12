//
//  ContentView.swift
//  HackUNT
//
//  Created by Hussain Alkatheri on 11/11/23.
//

import SwiftUI

struct item: Codable {
    let image: Int
    let category: String
}

func placeOrder(ID: Int, Category: String) async {
            // led?led1=1
            guard let url =  URL(string:"http://192.168.4.1/led")
            else{
                return
            }

            //### This is a little bit simplified. You may need to escape `username` and `password` when they can contain some special characters...
            let encoder = JSONEncoder()

    
            // Create a dictionary with your parameters
            let parameters = [Category: ID]

            // Convert the parameters to Data
            let postData = parameters.map { "\($0.key)=\($0.value)" }
                                    .joined(separator: "&")
                                    .data(using: .utf8)

            // Create a URLRequest
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postData
//    print(request.httpBody)
            print("\(request.httpMethod!) \(request.url!)")
            print(request.allHTTPHeaderFields!)
            print(String(data: request.httpBody ?? Data(), encoding: .utf8)!)
//            request.httpMethod = "POST"
            print(request)
//            URLSession.shared.dataTask(with: request){
//                (data, response, error) in
////                print(response as Any)
//                if let error = error {
//                    print(error)
//                    return
//                }
//                guard let data = data else{
//                    return
//                }
//                print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
//
//            }.resume()
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    // Handle the response data
                    let responseData = String(data: data, encoding: .utf8)
                    print("Response: \(responseData ?? "")")
                }
            }

            task.resume()

}


struct ContentView: View {
    var body: some View {
            NavigationView {
                VStack {
                    Button(LocalizedStringKey(stringLiteral: "Force OFF ")) {
                        Task(priority: .userInitiated) {
                           _ = await placeOrder(ID: 0, Category: "led1")
                           _ = await placeOrder(ID: 0, Category: "led2")
                           _ = await placeOrder(ID: 0, Category: "led3")
                           _ = await placeOrder(ID: 0, Category: "led4")
                        }
                    }
                    Button(LocalizedStringKey(stringLiteral: "ON")) {
                        Task(priority: .userInitiated) {
                           _ = await placeOrder(ID: 1, Category: "led1")
                        }
                    }
                    Text("Scan a name to find it's mailbox")
                        .font(.title)
                        .padding()
                    DocumentScannerView()
                        .navigationBarTitle("")
                        .navigationBarHidden(false)
                }
            }
        }
}

#Preview {
    ContentView()
}
