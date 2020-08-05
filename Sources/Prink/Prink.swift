@available (iOS 13.0, *)
public struct Prink {
    public static func provider(storageType: StorageType = .userDefaults) -> PrinkMetadataProvider {
        let repository: PrinkRepository = (storageType == .userDefaults) ? UserDefaultRepository() : OnMemoryRepository()
        return PrinkMetadataProvider(repository: repository)
    }
    
    public enum StorageType {
        case onMemory
        case userDefaults
    }
}
