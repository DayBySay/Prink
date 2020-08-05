//
//  PrinkRepository.swift
//  Prink
//
//  Created by Takayuki Sei on 2020/08/05.
//

import Foundation
import LinkPresentation

public protocol PrinkRepository {
    @available (iOS 13.0, *)
    func metadata(url: URL) -> LPLinkMetadata?
    @available (iOS 13.0, *)
    func store(metadata: LPLinkMetadata) -> Bool
}

@available (iOS 13.0, *)
internal class OnMemoryRepository: PrinkRepository {
    private var metadataDictionary: [URL: LPLinkMetadata] = [:]

    @available (iOS 13.0, *)
    func store(metadata: LPLinkMetadata) -> Bool {
        guard let url = metadata.url else { return false }
        metadataDictionary[url] = metadata
        return true
    }
    
    @available (iOS 13.0, *)
    func metadata(url: URL) -> LPLinkMetadata? {
        return metadataDictionary[url]
    }
}

internal class UserDefaultRepository: PrinkRepository {
    private let store = UserDefaults.standard
    private let key = "PrinkCache"
    
    @available (iOS 13.0, *)
    func store(metadata: LPLinkMetadata) -> Bool {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            var metadatas: [String: Data] = store.dictionary(forKey: self.key) as? [String: Data] ?? [:]
            metadatas[metadata.originalURL!.absoluteString] = data
            store.set(metadatas, forKey: key)
            return true
        } catch {
            return false
        }
    }
    
    @available (iOS 13.0, *)
    func metadata(url: URL) -> LPLinkMetadata? {
        guard let metadatas = store.dictionary(forKey: key) as? [String: Data],
            let data = metadatas[url.absoluteString] else {
            return nil
        }

        do {
            guard let metadata = try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data) else {
                return nil
            }
            
            return metadata
        } catch {
            return nil
        }
    }
}
