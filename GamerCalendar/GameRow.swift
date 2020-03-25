//
//  GameRow.swift
//  GamerCalendar
//
//  Created by Aleix Guri on 05/03/2020.
//  Copyright © 2020 crisredfi. All rights reserved.
//

import SwiftUI
import URLImage

struct GameRow: View {
    var game: GameModel
       var body: some View {

           HStack {
            URLImage( game.coverPhoto?.fileURL ?? URL(string: "https://images-na.ssl-images-amazon.com/images/I/81u-wZQV5EL._AC_SL1500_.jpg")! ) { _ in
                Image("death-stranding-201982112345528_1")
                .resizable()
                    .scaledToFit()
                    .frame(width: 70.0,
                    height: 70.0)
                .clipped()
                // Use different image for the placeholder
                }
                .scaledToFit()
                .frame(width: 70.0,
                       height: 70.0) // Set frame to 150x150
//                         .clipShape(Circle())
                         .clipped()

               Text(game.title)
               Spacer()
           }
       }
}

struct GameRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GameRow()
//    }
    static var previews: some View {
          Group {
            GameRow(game: GameModel.init())
            GameRow(game: GameModel.init())
          }
          .previewLayout(.fixed(width: 300, height: 70))
      }
}
