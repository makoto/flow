// Transaction1.cdc

import FungibleToken from 0x01

// This transaction creates the followings
// At prepare
// - Create empty vault
// - Set capability of each account into receiverRef
// At execute
// - Mint token to each user (1,2,3,40) tokens

transaction {
  // Local variable for storing the reference to the minter resource
  let mintingRef: &FungibleToken.VaultMinter

  // Local variable for storing the reference to the Vault of
  // the account that will receive the newly minted tokens
  var receiverRef: [&FungibleToken.Vault{FungibleToken.Receiver}]

  prepare(first: AuthAccount, second:AuthAccount, third:AuthAccount, forth: AuthAccount) {

    // Create a link to the Vault in storage that is restricted to the
    // fields and functions in `Receiver` and `Balance` interfaces, 
    // this only exposes the balance field 
    // and deposit function of the underlying vault.
    //
    // Set minting ref
    log("Set minting Ref")
    self.mintingRef = first.borrow<&FungibleToken.VaultMinter>
                                 (from: /storage/MainMinter)
                                        ?? panic("Could not borrow a reference to the minter")
		self.receiverRef = []

    log("Empty Vault stored")
    var array = [second, third, forth]
    for element  in array {
      let vault <- FungibleToken.createEmptyVault()
      element.save<@FungibleToken.Vault>(<-vault, to: /storage/MainVault)
    }
    array.insert(at:0, first)
    for element in array {
      log(element)
      // Link each account
      element.link<&FungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MainReceiver, target: /storage/MainVault)
      // set

      let recipient = getAccount(element.address)
      let cap = recipient.getCapability(/public/MainReceiver)!
      // Borrow a reference from the capability
      self.receiverRef.append( cap.borrow<&FungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>()
            ?? panic("Could not borrow a reference to the receiver"))
    }
  }

    execute {
      // Mint 30 tokens and deposit them into the recipient's Vault
      var tokens = [1,2,3,40]
      var a = 0
      log("Mint tokens")
      while a < tokens.length {
        log(tokens[a])
        self.mintingRef.mintTokens(amount: UFix64(tokens[a]), recipient: self.receiverRef[a])
        a = a+1;
      }
    }

  post {
    // Check that the capabilities were created correctly
    // by getting the public capability and checking 
    // that it points to a valid `Vault` object 
    // that implements the `Receiver` interface
    getAccount(0x01).getCapability(/public/MainReceiver)!
                    .check<&FungibleToken.Vault{FungibleToken.Receiver}>():
                    "0x01 Vault Receiver Reference was not created correctly"
    getAccount(0x02).getCapability(/public/MainReceiver)!
                    .check<&FungibleToken.Vault{FungibleToken.Receiver}>():
                    "0x02 Vault Receiver Reference was not created correctly"
    getAccount(0x03).getCapability(/public/MainReceiver)!
                    .check<&FungibleToken.Vault{FungibleToken.Receiver}>():
                    "0x03 Vault Receiver Reference was not created correctly"
    getAccount(0x04).getCapability(/public/MainReceiver)!
                    .check<&FungibleToken.Vault{FungibleToken.Receiver}>():
                    "0x04 Vault Receiver Reference was not created correctly"


    }
}
