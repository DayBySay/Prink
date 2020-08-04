//
//  PrinkRepository.swift
//  Prink
//
//  Created by Takayuki Sei on 2020/08/05.
//

import Foundation
import LinkPresentation

protocol MetadataProivder {
    func metadata(url: URL, completion: ((PrinkMetadata?, Error?) -> Void)?)
}

class PrinkMetadataProvider: MetadataProivder {
    private let repository: PrinkRepository
    
    init(repository: PrinkRepository) {
        self.repository = repository
    }
    
    func metadata(url: URL, completion: ((PrinkMetadata?, Error?) -> Void)?) {
        if let metadata = repository.metadata(url: url) {
            completion?(metadata, nil)
            return
        }
        
        fetchMetadata(url: url, completion: completion)
    }

    private func fetchMetadata(url: URL, completion: ((PrinkMetadata?, Error?) -> Void)?) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { (metadata, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion?(nil, error)
                    return
                }
                
                guard let metadata = metadata else {
                    completion?(nil, nil)
                    return
                }
                
                completion?(PrinkMetadata(metadata: metadata), nil)
            }
        }
    }
}

protocol PrinkRepository {
    func metadata(url: URL) -> PrinkMetadata?
    func store(metadata: PrinkMetadata) -> Bool
}

internal class UserDefaultRepository: PrinkRepository {
    private let store = UserDefaults.standard
    private let key = "PrinkCache"
    
    func store(metadata: PrinkMetadata) -> Bool {
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
    
    func metadata(url: URL) -> PrinkMetadata? {
        guard let metadatas = store.dictionary(forKey: key) as? [String: Data],
            let data = metadatas[url.absoluteString] else {
            return nil
        }

        do {
            guard let metadata = try NSKeyedUnarchiver.unarchivedObject(ofClass: PrinkMetadata.self, from: data) else {
                return nil
            }
            
            return metadata
        } catch {
            return nil
        }
    }
}
