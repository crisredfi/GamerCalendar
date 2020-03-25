//
//  CloudModel.swift
//  GamerCalendar
//
//  Created by Aleix Guri on 03/03/2020.
//  Copyright © 2020 crisredfi. All rights reserved.
//

import Foundation
import CloudKit
import SwiftUI

struct RecordType {
    static let Items = "Items"
}
enum CloudKitHelperError: Error {
    case recordFailure
    case recordIDFailure
    case castFailure
    case cursorFailure
}

class CloudModel {
    let container: CKContainer
    let publicDb: CKDatabase
    let privateDb: CKDatabase
    
    private(set) var games: [GameModel] = []
    static var currentModel = CloudModel()
    
    init() {
        container = CKContainer.default()
        publicDb = container.publicCloudDatabase
        privateDb = container.privateCloudDatabase
    }
    
    func refresh(_ completion: @escaping (Result<[GameModel], Error>) -> Void) {
        let predicate =  NSPredicate(value: true)
        let query = CKQuery(recordType: "Game", predicate: predicate)
        games(forQuery: query,completion)
        
    }
    
    private func games(forQuery query: CKQuery, _ completion: @escaping (Result<[GameModel], Error>) -> Void) {
        privateDb.perform(query, inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
            guard let self = self else {
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let results = results else {
                return
            }
            self.games = results.compactMap {
                GameModel(record: $0, database: self.publicDb)
            }
            DispatchQueue.main.async {
                completion(.success(self.games))
            }
        }
        
        
    }
    
    static func save(item: GameModel, completion: @escaping (Result<GameModel, Error>) -> ()) {
        let itemRecord = item.convertToRecord()
          
          CKContainer.default().privateCloudDatabase.save(itemRecord) { (record, err) in
              DispatchQueue.main.async {
                  if let err = err {
                      completion(.failure(err))
                      return
                  }
                  guard let record = record else {
                      completion(.failure(CloudKitHelperError.recordFailure))
                      return
                  }
                  let _ = record.recordID
                  guard let _ = record["title"] as? String else {
                      completion(.failure(CloudKitHelperError.castFailure))
                      return
                  }
                  
                  completion(.success(item))
              }
          }
      }
    
    // MARK: - delete from CloudKit
    static func delete(recordID: CKRecord.ID, completion: @escaping (Result<CKRecord.ID, Error>) -> ()) {
        CKContainer.default().privateCloudDatabase.delete(withRecordID: recordID) { (recordID, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let recordID = recordID else {
                    completion(.failure(CloudKitHelperError.recordIDFailure))
                    return
                }
                completion(.success(recordID))
            }
        }
    }
    
    // MARK: - modify in CloudKit
    static func modify(item: GameModel, completion: @escaping (Result<GameModel, Error>) -> ()) {
        let recordID = item.id
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, err in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            guard let record = record else {
                DispatchQueue.main.async {
                    completion(.failure(CloudKitHelperError.recordFailure))
                }
                return
            }
            record["title"] = item.title as CKRecordValue

            CKContainer.default().publicCloudDatabase.save(record) { (record, err) in
                DispatchQueue.main.async {
                    if let err = err {
                        completion(.failure(err))
                        return
                    }
                    guard let record = record else {
                        completion(.failure(CloudKitHelperError.recordFailure))
                        return
                    }
                    let recordID = record.recordID
                    guard let text = record["title"] as? String else {
                        completion(.failure(CloudKitHelperError.castFailure))
                        return
                    }
                    completion(.success(item))

                }
            }
        }
    }
}
