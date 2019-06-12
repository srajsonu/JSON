//
//  ContentView.swift
//  JSON
//
//  Created by ARY@N on 12/06/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import SwiftUI
import Combine

struct Course: Decodable{
    let name, imageURL: String
}

class NetworkManager: BindableObject {
    var didChange = PassthroughSubject<NetworkManager,Never>()
    
    var courses = [Course]() {
        didSet {
            didChange.send(self)
        }
    }
    init() {
        guard let url = URL(string: "http://api.letsbuildthatapp.com/jsondecodable/courses") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            
            let course = try! JSONDecoder().decode([Course].self, from: data)
            
            DispatchQueue.main.async {
                self.courses = course
            }
            
            print("Completed fetching")
        }.resume()
    }
}

struct ContentView : View {
    
    @State var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView{
            List(networkManager.courses.identified(by: \.name)){
                Text($0.name)
                }.navigationBarTitle(Text("Courses"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
