# SwiftPackageWordLookup

Simple Swift Package to lookup the word using Dictionary API and return the result back to the caller with the help of the completion handler.

To use it, just call the SwiftPackageWordLookup with your Oxford Dictionary application key and application ID and then the result of the word lookup would be returned in the completion handler, which needs to be parsed as needed by the caller.

API Used
-------

This packade uses the Oxford Dictionary API to make the word lookups.
* Base URL : "https://od-api.oxforddictionaries.com/api/v2"
* Endpoint : "/entries"

Usage
-------
```
func testLookupWord() {

let lookup = SwiftPackageWordLookup(appKey: "xxxx",
appID: "xxxx")

lookup.lookupWord(word: "contemplate") { (meaning:String?, error:Error?) in

guard error == nil else {

return

}

print("Meaning: \(meaning!)")

// parse the word as needed.

}
}
```
