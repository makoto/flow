import FungibleToken from 0x01cf0e2f2f715450

transaction{
  prepare(acct: AuthAccount){
    let vaultA <- FungibleToken.createEmptyVault()
    acct.save<@FungibleToken.Vault>(<-vaultA, to: /storage/MainVault)
    log("Empty Vault stored")
    let ReceiverRef = acct.link<&FungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MainReceiver, target: /storage/MainVault)
    log("Reference created")
  }

  post{
    getAccount(0x179b6b1cb6755e31)
      .getCapability(/public/MainReceiver)!
      .check<&FungibleToken.Vault{FungibleToken.Receiver}>(): "Vault Receiver Reference was not created correctly"

  }
}
 