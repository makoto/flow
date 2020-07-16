import FungibleToken from 0x01cf0e2f2f715450

transaction{
  let mintingRef: &FungibleToken.VaultMinter
  var receiverRef: &FungibleToken.Vault{FungibleToken.Receiver}
  prepare(acct: AuthAccount){
    self.mintingRef = acct.borrow<&FungibleToken.VaultMinter>(from: /storage/MainMinter)!
    let recipient = getAccount(0x01cf0e2f2f715450)
    let cap = recipient.getCapability(/public/MainReceiver)!
    self.receiverRef = cap.borrow<&FungibleToken.Vault{FungibleToken.Receiver}>()!
  } 

  execute{
    self.mintingRef.mintTokens(amount: UFix64(30), recipient: self.receiverRef)
    log("30 tokens minted and deposit to account 0x01")
  }
}
 