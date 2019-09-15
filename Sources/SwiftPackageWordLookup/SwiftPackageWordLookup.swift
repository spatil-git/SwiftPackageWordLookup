public struct SwiftPackageWordLookup {
    let appKey:String
    let appID:String
    func lookupWord(word:String, completionHandler:@escaping ((String?, Error?)->Void)) {
        let dictLookup = DictionaryAPIHandler(appID: appID,
                                              appKey: appKey)
        dictLookup.lookupWord(word, competionHandler: completionHandler)
    }
}
