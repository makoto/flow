
import GiveMe1000GiveYou2000Token from 0x01cf0e2f2f715450

// Title: Send me one kitty, I will give two back.
// Inspired by latest Twitter hack where hacker is asking to send 1000 Bitcoin to return 2000 bitcoin back.

transaction {

    let receiverRef: &{GiveMe1000GiveYou2000Token.NFTReceiver}
    let minterRef: &GiveMe1000GiveYou2000Token.NFTMinter
    let collectionRef: &GiveMe1000GiveYou2000Token.Collection
    let myCollections: &GiveMe1000GiveYou2000Token.Collection

    prepare(acct: AuthAccount) {
        self.receiverRef = acct.getCapability(/public/NFTReceiver)!.borrow<&{GiveMe1000GiveYou2000Token.NFTReceiver}>()!
        self.minterRef = acct.borrow<&GiveMe1000GiveYou2000Token.NFTMinter>(from: /storage/NFTMinter)!
        self.collectionRef = acct.borrow<&GiveMe1000GiveYou2000Token.Collection>(from: /storage/NFTCollection)!
        
        let collection <- GiveMe1000GiveYou2000Token.createEmptyCollection()
        if let oldToken <- acct.load<@GiveMe1000GiveYou2000Token.Collection>(from: /storage/MyCollection) {
            destroy oldToken
        }
        
        acct.save<@GiveMe1000GiveYou2000Token.Collection>(<-collection, to: /storage/MyCollection)
        
        self.myCollections = acct.borrow<&GiveMe1000GiveYou2000Token.Collection>(from: /storage/MyCollection)!
    }

    execute {
        var a = 1
        log("Kities go brrrrrrr")
        while a <= 6 {
            let ids = self.minterRef.mintNFT(nfts: self.myCollections, recipient: self.receiverRef)
            var temp = 0
            var i = 0
            while i < ids.length {
                temp = ids[i]
                var j = i + 1
                while j < ids.length {
                    if (temp > ids[j]) {
                        ids[i] = ids[j]
                        ids[j] = temp
                        temp = ids[i]
                    }
                    j = j + 1
                }
                i = i +1
            }
            log(ids)

            for element in ids {
                if let token <- self.collectionRef.withdraw(withdrawID: UInt64(element)){
                    self.myCollections.deposit(token: <-token)
                } 
            }
            a = a+1
        }
    }
}
 