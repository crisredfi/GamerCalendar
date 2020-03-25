//
//  NewGameView.swift
//  GamerCalendar
//
//  Created by Aleix Guri on 05/03/2020.
//  Copyright © 2020 crisredfi. All rights reserved.
//

import SwiftUI

struct NewGameView: View {
    @State private var title: String = ""
    @State private var platform: String = ""
    @State private var pricePayed: String = ""
    @State private var timePlayed: String = "0"
    @State private var startDate: Date = Date()
    
    var body: some View {
        NavigationView {
            Form{
                HStack() {
                    Text("Game Title")
                    Spacer()
                    TextField("Enter game Name", text: $title).multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("platform")
                    Spacer()
                    TextField("Enter platform Name", text: $platform).multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("price payed")
                    Spacer()
                    TextField("Enter price payed", text: $pricePayed).multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("time payed")
                    Spacer()
                    
                    TextField("Enter time payed", text: $timePlayed).multilineTextAlignment(.trailing)
                }
                DatePicker("Please enter a StartDate", selection: $startDate, displayedComponents: .date)

            }
            .padding(.top, 0)
            
          
            
              
        }.navigationBarTitle("Create new game")
        .navigationBarItems(trailing:   Button(action: {
            let testModel = GameModel(title: self.title,
                                      timePlayed: Double(self.timePlayed)!,
                                      pricePayed: Double(self.pricePayed)!,
                                      platform: self.platform,
                                      startDate: Date(),
                                      coverPhoto: nil)

            CloudModel.save(item: testModel) { _ in
                
            }
             }, label: {
                Text("Save")
            }))
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameView()
    }
}
