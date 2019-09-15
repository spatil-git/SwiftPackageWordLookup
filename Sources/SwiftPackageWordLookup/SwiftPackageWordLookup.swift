public struct SwiftPackageWordLookup {
    let appKey:String
    let appID:String
    public init(appKey:String, appID:String) {
        self.appKey = appKey
        self.appID = appID
    }
    public func lookupWord(word:String, completionHandler:@escaping ((String?, Error?)->Void)) {
        let dictLookup = DictionaryAPIHandler(appID: appID,
                                              appKey: appKey)
        dictLookup.lookupWord(word, competionHandler: completionHandler)
    }
}
