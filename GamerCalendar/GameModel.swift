//
//  GameModel.swift
//  GamerCalendar
//
//  Created by Aleix Guri on 03/03/2020.
//  Copyright © 2020 crisredfi. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import SwiftUI

class GameModel: ObservableObject, Identifiable {
    enum gamePlatform: Int {
        case playstation
        case xbox
        case pc
        case nintendoSwitch
    }
    
    static let recordType = "Game"
    let id: CKRecord.ID
    let title: String
    var timePlayed: Double?
    let pricePayed: Double?
    var coverPhoto: CKAsset?
    var platform: String
    var startDate: Date
    var endDate: Date?
    var database: CKDatabase?
    
    init(title: String = "test",
         timePlayed: Double =  0,
         pricePayed: Double = 0,
         platform: String = "Playstation",
         startDate: Date = Date(),
         coverPhoto: CKAsset? = nil) {
        self.title = title
        self.timePlayed = timePlayed
        self.pricePayed = pricePayed
        self.platform = "Playstation"
        self.startDate = Date()
        self.id = CKRecord.ID.init()
        self.coverPhoto = nil
        self.endDate = Date()
        self.database = nil
    }
    
    init?(record: CKRecord, database: CKDatabase) {
        guard let title = record["title"] as? String,
            let platform = record["platform"] as? String else {
                return nil
        }
        self.title = title
        self.platform = platform
        id = record.recordID
        timePlayed = record["timePlayed"] as? Double ?? 0
        pricePayed = record["pricePayed"] as? Double ?? 0
        coverPhoto = record["coverPhoto"] as? CKAsset
        self.database = database
        startDate = record["startDate"] as? Date ?? Date()
        endDate = record["endDate"] as? Date
                
    }
    
    func convertToRecord() -> CKRecord {
        let record =  CKRecord(recordType: "Game")
        record["title"] = self.title
        record["platform"] = self.platform
        record["timePlayed"] = self.timePlayed
        record["startDate"] = self.startDate
        return record
    }
    
    
    func loadCoverPhoto(completion: @escaping (_ photo: UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
          var image: UIImage?
          defer {
            DispatchQueue.main.async {
              completion(image)
            }
          }
          guard
            let coverPhoto = self.coverPhoto,
            let fileURL = coverPhoto.fileURL
            else {
              return
          }
          let imageData: Data
          do {
            imageData = try Data(contentsOf: fileURL)
          } catch {
            return
          }
          image = UIImage(data: imageData)
        }
      }
    
}

extension GameModel: Hashable {
    static func == (lhs: GameModel, rhs: GameModel) -> Bool {
       return lhs.id == rhs.id
     }
     
     func hash(into hasher: inout Hasher) {
       hasher.combine(id)
     }

}
