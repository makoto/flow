
import NonFungibleToken from 0x01cf0e2f2f715450

// Title: Send me one kitty, I will give two back.
// Inspired by latest Twitter hack where hacker is asking to send 1000 Bitcoin to return 2000 bitcoin back.

transaction {

    let receiverRef: &{NonFungibleToken.NFTReceiver}
    let minterRef: &NonFungibleToken.NFTMinter
    let collectionRef: &NonFungibleToken.Collection
    let myCollections: &NonFungibleToken.Collection

    prepare(acct: AuthAccount) {
        self.receiverRef = acct.getCapability(/public/NFTReceiver)!.borrow<&{NonFungibleToken.NFTReceiver}>()!
        self.minterRef = acct.borrow<&NonFungibleToken.NFTMinter>(from: /storage/NFTMinter)!
        self.collectionRef = acct.borrow<&NonFungibleToken.Collection>(from: /storage/NFTCollection)!
        
        let collection <- NonFungibleToken.createEmptyCollection()
        if let oldToken <- acct.load<@NonFungibleToken.Collection>(from: /storage/MyCollection) {
            destroy oldToken
        }
        
        acct.save<@NonFungibleToken.Collection>(<-collection, to: /storage/MyCollection)
        
        self.myCollections = acct.borrow<&NonFungibleToken.Collection>(from: /storage/MyCollection)!
        

    }

    execute {
        log("my collection number1")
        log(self.myCollections.getIDs())
        log("First round... send zero and get 1")
        let firstRound = self.minterRef.mintNFT(nfts: self.myCollections, recipient: self.receiverRef)
        log("firstRound")
        log(firstRound)

        for element in firstRound {
            log("element")
            log(element)
            if let token <- self.collectionRef.withdraw(withdrawID: UInt64(element)){
                log("my collection number3")
                log(self.myCollections.getIDs())

                self.myCollections.deposit(token: <-token)
                log("my collection number4")
                log(self.myCollections.getIDs())
            }else{
                log("No token for this element")
                log(element)
            }
            
        }
        log("Second round... send 1 and get 2")
        log("my collection number5")
        log(self.myCollections.getIDs())

        let secondRound = self.minterRef.mintNFT(nfts: self.myCollections, recipient: self.receiverRef)
        log(secondRound)
        // for element in self.myCollections.getIDs() {
        // }        
    }
}
 