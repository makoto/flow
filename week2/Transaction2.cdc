
import NonFungibleToken from 0x01cf0e2f2f715450

// Title: Send me one kitty, I will give two back.
// Inspired by latest Twitter hack where hacker is asking to send 1000 Bitcoin to return 2000 bitcoin back.

transaction {

    let receiverRef: &{NonFungibleToken.NFTReceiver}
    let minterRef: &NonFungibleToken.NFTMinter

    let collectionRef: &NonFungibleToken.Collection
    let myCollections: &NonFungibleToken.Collection
    prepare(acct: AuthAccount) {
        self.receiverRef = acct.getCapability(/public/NFTReceiver)!
                               .borrow<&{NonFungibleToken.NFTReceiver}>()!
        
        self.minterRef = acct.borrow<&NonFungibleToken.NFTMinter>(from: /storage/NFTMinter)!
        self.collectionRef = acct.borrow<&NonFungibleToken.Collection>(from: /storage/NFTCollection)!
        let collection <- NonFungibleToken.createEmptyCollection()
        acct.save<@NonFungibleToken.Collection>(<-collection, to: /storage/MyCollection)
        self.myCollections = acct.borrow<&NonFungibleToken.Collection>(from: /storage/MyCollection)!
    }

    execute {
        let firstRound = self.minterRef.mintNFT(nfts: self.myCollections, recipient: self.receiverRef)
        // First round, send zero, and get 1.
        for element in firstRound {
            log(element)
            self.myCollections.deposit(token:<- self.collectionRef.withdraw(withdrawID: UInt64(element)))
        }
        // Sedon round, send 1 and get 2 back.
        for element in self.myCollections.getIDs() {
            log(element)
            let secondRound = self.minterRef.mintNFT(nfts: self.myCollections, recipient: self.receiverRef)
        }
    }
}
 