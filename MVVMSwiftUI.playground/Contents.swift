/*
    Example MVVM Pattern with SwiftUI
 */

import SwiftUI
import PlaygroundSupport
//import Combine


// ------------- Modelo ----------------
struct Person: Codable{
    let id: UUID
    let name: String
    let apells: String
    let nif: String
}

enum Status{
    case none, loading, loaded, error
}

// ---------------- ViewModel ------------


final class PersonViewModel: ObservableObject{
    @Published var data: Person?
    @Published var status = Status.none //ViewModel status
    
    init(){
        //Load employee
        loadPerson() //call load
    }
    //Load person from simulated network
    func loadPerson(){
        status = Status.loading
        //Asynchronous execution at 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            //Task to do it
            self.data = Person(id: UUID(), name: "Jose Luis", apells: "Bustos Lopez", nif: "502526272J")
            
            //satus Ok
            self.status = Status.loaded
        }
    }
    
}


// ---------------- View ----------------------

//https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-stateobject-property-wrapper

struct ContentView: View{
    // ViewModel reference
    @StateObject private var viewModel = PersonViewModel()
    
    var body: some View{
    
        switch viewModel.status{
        case Status.none:
            Text("Do nothing")
        case Status.loading:
            Text("Loading data")
        case Status.error:
            Text("there is an error")
        case Status.loaded:
            VStack{
                if let data = viewModel.data{
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("\(data.name) \(data.apells)")
                        .font(.caption)
                } else{
                    Text("No data")
                }
            }
            .padding()
            //Events which show us changes in viewMidel published attributes
            .onReceive(self.viewModel.$data) { data in
                print("Model data change")
            }
            .onReceive(self.viewModel.$status) { status in
                print("Status change \(status)")
            }
        }
    }
}


PlaygroundPage.current.setLiveView(ContentView().frame(width: 200, height: 200))
