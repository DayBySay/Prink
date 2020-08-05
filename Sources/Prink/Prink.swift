public struct Prink {
    public static func provider(storageType: StorageType = .userDefaults) -> PrinkMetadataProvider {
        var repository: PrinkRepository = UserDefaultRepository()
        if #available (iOS 13.0, *) {
            repository = (storageType == .userDefaults) ? UserDefaultRepository() : OnMemoryRepository()
        }
        return PrinkMetadataProvider(repository: repository)
    }
    
    public enum StorageType {
        case userDefaults
        @available (iOS 13.0, *)
        case onMemory
    }
}
