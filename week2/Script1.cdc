// Script1.cdc 

import NonFungibleToken from 0x01cf0e2f2f715450

// Print the NFTs owned by account 0x03.
pub fun main() {
    // Get the public account object for account 0x03
    let nftOwner = getAccount(0x01cf0e2f2f715450)

    // Find the public Receiver capability for their Collection
    let capability = nftOwner.getCapability(/public/NFTReceiver)!

    // borrow a reference from the capability
    let receiverRef = capability.borrow<&{NonFungibleToken.NFTReceiver}>()!

    // Log the NFTs that they own as an array of IDs
    log("Account 2 NFTs")
    log(receiverRef.getIDs())
}
