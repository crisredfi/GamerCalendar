////
////  ContentView.swift
////  GamerCalendar
////
////  Created by Aleix Guri on 03/03/2020.
////  Copyright © 2020 crisredfi. All rights reserved.
////
//
//import SwiftUI
//
//private let dateFormatter: DateFormatter = {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .medium
//    dateFormatter.timeStyle = .medium
//    return dateFormatter
//}()
//
//struct ContentView: View {
////    @Environment(\.managedObjectContext)
////    var viewContext
// @EnvironmentObject var listElements: ListElements
//
//    var body: some View {
//        NavigationView {
//            MasterView()
//                .navigationBarTitle(Text("Master"))
//                .navigationBarItems(
//                    leading: EditButton(),
//                    trailing: Button(
//                        action: {
//                         //   withAnimation { Event.create(in: self.viewContext) }
//                        }
//                    ) {
//                        Image(systemName: "plus")
//                    }
//            ).environmentObject(listElements)
//            Text("Detail view content goes here")
//                .navigationBarTitle(Text("Detail"))
//        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
//    }
//}
//
//struct MasterView: View {
////    @FetchRequest(
////        sortDescriptors: [NSSortDescriptor(keyPath: \GameModel.title, ascending: true)],
////        animation: .default)
////    var events: FetchedResults<GameModel>
//
////    @Environment(\.managedObjectContext)
// //   var viewContext
//    @EnvironmentObject var listElements: ListElements
//
//    var body: some View {
//        List(listElements.items) { item in
//                           HStack(spacing: 15) {
//                            Text(item.title)
//                           }
//                       }
//        .onAppear {
//            // MARK: - fetch from CloudKit
////            let model = CloudModel()
////            model.refresh { (result) in
////                switch result {
////                    case .success(let newList):
////                        self.listElements.items.append(contentsOf: newList)
////                case .failure(let err):
////                    print(err.localizedDescription)
////                }
////            }
////                     CloudModel.refresh { (result) in
////                         switch result {
////                         case .success(let newItem):
////                             self.listElements.items.append(newItem)
////                             print("Successfully fetched item")
////                         case .failure(let err):
////                             print(err.localizedDescription)
////                         }
////                     }
//        }
//
//    }
////        List {
////            ForEach(events, id: \.self) { event in
////                NavigationLink(
////                    destination: DetailView(event: event)
////                ) {
////                    Text("\(event.timestamp!, formatter: dateFormatter)")
////                }
////            }.onDelete { indices in
////                self.events.delete(at: indices, from: self.viewContext)
////            }
////        }
// //   }
//}
//
//struct DetailView: View {
//    @ObservedObject var event: Event
//
//    var body: some View {
//        Text("\(event.timestamp!, formatter: dateFormatter)")
//            .navigationBarTitle(Text("Detail"))
//    }
//}
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
////struct ContentView_Previews: PreviewProvider {
////    static var previews: some View {
////        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////        return ContentView().environment(\.managedObjectContext, context)
////    }
////}

import SwiftUI

struct ContentView: View {
    let model = CloudModel()

    @EnvironmentObject var listElements: ListElements
    @State private var showEditTextField = false
    
    var body: some View {
        NavigationView {
            VStack {
                List { ForEach(listElements.items) { game in
                           NavigationLink(destination: GameDetail(game: game)) {
                               GameRow(game: game)
                    }
                }.onDelete { (set) in
                    self.delete(at: set)
                    }
                    
            }
                .animation(.easeInOut)
            
            }
            .navigationBarTitle(Text("Game Calendar"))
        .navigationBarItems(trailing:
            NavigationLink(destination: NewGameView()) {
                Text("New Item")
            }
         
            )
        }
        .onAppear {
            // MARK: - fetch from CloudKit
            self.model.refresh { (result) in
                        switch result {
                            case .success(let newList):
                                self.listElements.items.append(contentsOf: newList)
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                    }
                    
//            CloudKitHelper.fetch { (result) in
//                switch result {
//                case .success(let newItem):
//                    self.listElements.items.append(newItem)
//                    print("Successfully fetched item")
//                case .failure(let err):
//                    print(err.localizedDescription)
//                }
//            }
        }
    }
    
    func delete(at offsets: IndexSet) {

          guard let index = Array(offsets).first else { return }
    
        CloudModel.delete(recordID: self.listElements.items[index].id) { (result) in
            switch (result) {
            case .success(let _):
                        print("success")
                        self.listElements.items.remove(at: index)
            default:
                print("failed")
            }
        
        }
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
