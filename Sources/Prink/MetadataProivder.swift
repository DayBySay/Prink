//
//  MetadataProivder.swift
//  Prink
//
//  Created by Takayuki Sei on 2020/08/05.
//

import Foundation
import LinkPresentation

public protocol MetadataProivder {
    @available (iOS 13.0, *)
    func metadata(url: URL, completion: ((LPLinkMetadata?, Error?) -> Void)?)
}

public class PrinkMetadataProvider: MetadataProivder {
    private let repository: PrinkRepository
    
    public init(repository: PrinkRepository) {
        self.repository = repository
    }
    
    @available (iOS 13.0, *)
    public func metadata(url: URL, completion: ((LPLinkMetadata?, Error?) -> Void)?) {
        if let metadata = repository.metadata(url: url) {
            completion?(metadata, nil)
            return
        }
        
        fetchMetadata(url: url, completion: completion)
    }
    
    @available (iOS 13.0, *)
    private func fetchMetadata(url: URL, completion: ((LPLinkMetadata?, Error?) -> Void)?) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { [weak self] (metadata, error) in
            if let error = error {
                completion?(nil, error)
                return
            }

            if let metadata = metadata {
                _ = self?.repository.store(metadata: metadata)
            }
            completion?(metadata, nil)
        }
    }
}
