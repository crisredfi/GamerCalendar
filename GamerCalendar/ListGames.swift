//
//  ListGames.swift
//  GamerCalendar
//
//  Created by Aleix Guri on 03/03/2020.
//  Copyright © 2020 crisredfi. All rights reserved.
//

import SwiftUI

class ListElements: ObservableObject {
    @Published var items: [GameModel] = []
}
