//
//  PrinkMetadata.swift
//  Prink
//
//  Created by Takayuki Sei on 2020/08/05.
//

import Foundation
import UIKit
import LinkPresentation

public class PrinkMetadata: NSObject, NSCoding {
    public var url: URL? { lpLinkMetadata.url }
    public var originalURL: URL? { lpLinkMetadata.originalURL }
    public var remoteVideoURL: URL? { lpLinkMetadata.remoteVideoURL }
    public var title: String? { lpLinkMetadata.title }
    public let lpLinkMetadata: LPLinkMetadata
    private let key = "lpLinkMetadata"
    
    public init(metadata: LPLinkMetadata) {
        self.lpLinkMetadata = metadata
    }
    
    required public init?(coder: NSCoder) {
        self.lpLinkMetadata = coder.decodeObject(forKey: key) as! LPLinkMetadata
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(lpLinkMetadata, forKey: key)
    }
    
    public func image(completion: ((UIImage?, Error?) -> Void)?) {
        guard let provider = lpLinkMetadata.imageProvider,
            provider.canLoadObject(ofClass: UIImage.self) else {
                completion?(nil, nil)
            return 
        }
        
        provider.loadObject(ofClass: UIImage.self) { (bridgeable, error) in
            if let error = error {
                completion?(nil, error)
                return
            }
            
            guard let image = bridgeable as? UIImage else {
                completion?(nil, nil)
                return
            }
            
            completion?(image, nil)
        }
    }
    
    public func icon(completion: ((UIImage?, Error?) -> Void)?) {
        guard let provider = lpLinkMetadata.imageProvider,
            provider.canLoadObject(ofClass: UIImage.self) else {
                completion?(nil, nil)
                return
        }
        
        provider.loadObject(ofClass: UIImage.self) { (bridgeable, error) in
            if let error = error {
                completion?(nil, error)
                return
            }
            
            guard let icon = bridgeable as? UIImage else {
                completion?(nil, nil)
                return
            }
            
            completion?(icon, nil)
        }
    }
}
