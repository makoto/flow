// Transaction2.cdc

import NonFungibleToken from 0x01cf0e2f2f715450

// This transaction allows the Minter account to mint an NFT
// and deposit it into its collection.

transaction {

    // The reference to the collection that will be receiving the NFT
    let receiverRef: &{NonFungibleToken.NFTReceiver}
    // The reference to the Minter resource stored in account storage
    let minterRef: &NonFungibleToken.NFTMinter

    let collectionRef: &NonFungibleToken.Collection
    let myCollections: &NonFungibleToken.Collection
    prepare(acct: AuthAccount) {
        // Get the owner's collection capability and borrow a reference
        self.receiverRef = acct.getCapability(/public/NFTReceiver)!
                               .borrow<&{NonFungibleToken.NFTReceiver}>()!
        
        // Borrow a capability for the NFTMinter in storage
        self.minterRef = acct.borrow<&NonFungibleToken.NFTMinter>(from: /storage/NFTMinter)!
        self.collectionRef = acct.borrow<&NonFungibleToken.Collection>(from: /storage/NFTCollection)!
        let collection <- NonFungibleToken.createEmptyCollection()
        acct.save<@NonFungibleToken.Collection>(<-collection, to: /storage/MyCollection)
        self.myCollections = acct.borrow<&NonFungibleToken.Collection>(from: /storage/MyCollection)!
    }

    execute {
        let firstRound = self.minterRef.mintNFT(nfts: self.myCollections, recipient: self.receiverRef)
        for element in firstRound {
            log(element)
            self.myCollections.deposit(token:<- self.collectionRef.withdraw(withdrawID: UInt64(element)))
        }
        for element in self.myCollections.getIDs() {
            log(element)
            let secondRound = self.minterRef.mintNFT(nfts: self.myCollections, recipient: self.receiverRef)
        }
    }
}
 