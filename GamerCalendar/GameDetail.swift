//
//  GameDetail.swift
//  GamerCalendar
//
//  Created by Aleix Guri on 05/03/2020.
//  Copyright © 2020 crisredfi. All rights reserved.
//

import SwiftUI
import URLImage

struct GameDetail: View {
    var game: GameModel
    @State private var showImagePicker : Bool = false
    @State private var image : Image? = nil

    var body: some View {
        VStack {
            Text(game.title).frame( height: 40.0, alignment: .leading)
            Text(game.platform).frame( height: 40.0, alignment: .leading)
            Text(game.startDate.debugDescription).frame( height: 40.0, alignment: .leading)
            self.image != nil ? self.image!
                            .resizable()
                            .scaledToFit()
                .frame(width: 170.0,
                                  height: 170.0)
                            .clipped() : nil
            
            self.image == nil ? (URLImage( game.coverPhoto?.fileURL ?? URL(string: "https://images-na.ssl-images-amazon.com/images/I/81u-wZQV5EL._AC_SL1500_.jpg")! ) { proxy in
                  proxy.image
                    .resizable()
                    .scaledToFit()
                    .clipped()
                // Use different image for the placeholder
            }
            .scaledToFit()
            .frame(width: 170.0,
                   height: 170.0) as? Image ) // Set frame to 150x150
                : nil
            
            Text(game.title)
            Spacer()
            Button(action: {
                self.showImagePicker = true

            }) {
                Text("update Image")
            }.sheet(isPresented: self.$showImagePicker) {
                 PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
               // print(capture)
            }
            Spacer()
        }
    }
}



struct GameDetail_Previews: PreviewProvider {
    static var previews: some View {
        GameDetail(game: GameModel.init())
    }
}
