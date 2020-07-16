// Transaction2.cdc

import NonFungibleToken from 0x01cf0e2f2f715450

// This transaction allows the Minter account to mint an NFT
// and deposit it into its collection.

transaction {

    // The reference to the collection that will be receiving the NFT
    let receiverRef: &{NonFungibleToken.NFTReceiver}

    // The reference to the Minter resource stored in account storage
    let minterRef: &NonFungibleToken.NFTMinter

    // let collectionRef: &NonFungibleToken.Collection
    prepare(acct: AuthAccount) {
        // Get the owner's collection capability and borrow a reference
        self.receiverRef = acct.getCapability(/public/NFTReceiver)!
                               .borrow<&{NonFungibleToken.NFTReceiver}>()!
        
        // Borrow a capability for the NFTMinter in storage
        self.minterRef = acct.borrow<&NonFungibleToken.NFTMinter>(from: /storage/NFTMinter)!
        // self.collectionRef = acct.borrow<&NonFungibleToken.Collection>(from: /storage/NFTCollection)!
    }

    execute {
        // Use the minter reference to mint an NFT, which deposits
        // the NFT into the collection that is sent as a parameter.
        self.minterRef.mintNFT(num: 3, recipient: self.receiverRef)

        log("NFT Minted and deposited to Account 2's Collection")

        log("Account 2 NFTs")

        log(self.receiverRef.getIDs())

        // Call the withdraw function on the sender's Collection
        // to move the NFT out of the collection
        // let transferToken <- self.collectionRef.withdraw(withdrawID: 1)

    }
}
 