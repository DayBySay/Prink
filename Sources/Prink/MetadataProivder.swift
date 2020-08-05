//
//  MetadataProivder.swift
//  Prink
//
//  Created by Takayuki Sei on 2020/08/05.
//

import Foundation
import LinkPresentation

@available (iOS 13.0, *)
public protocol MetadataProivder {
    func metadata(url: URL, completion: ((LPLinkMetadata?, Error?) -> Void)?)
}

@available (iOS 13.0, *)
public class PrinkMetadataProvider: MetadataProivder {
    private let repository: PrinkRepository
    
    public init(repository: PrinkRepository) {
        self.repository = repository
    }
    
    public func metadata(url: URL, completion: ((LPLinkMetadata?, Error?) -> Void)?) {
        if let metadata = repository.metadata(url: url) {
            completion?(metadata, nil)
            return
        }
        
        fetchMetadata(url: url, completion: completion)
    }
    
    private func fetchMetadata(url: URL, completion: ((LPLinkMetadata?, Error?) -> Void)?) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { (metadata, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion?(nil, error)
                    return
                }
                
                completion?(metadata, nil)
            }
        }
    }
}
