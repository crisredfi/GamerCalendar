//
//  HomeView.swift
//  GamerCalendar
//
//  Created by Aleix Guri on 05/03/2020.
//  Copyright © 2020 crisredfi. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var myTestList: [GameModel] = [GameModel()]
    var body: some View {
        NavigationView {
            List(myTestList) { game in
                NavigationLink(destination: GameDetail(game: game)) {
                    GameRow(game: game)
                }
            }
            .navigationBarTitle(Text("Game Calendar"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
