import FungibleToken from 0x01cf0e2f2f715450

transaction{
  prepare(acct: AuthAccount){
    acct.link<&FungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MainReceiver, target: /storage/MainVault)
    log("Public Receiver reference created!")
  }

  post{
    getAccount(0x01cf0e2f2f715450)
      .getCapability(/public/MainReceiver)!
      .check<&FungibleToken.Vault{FungibleToken.Receiver}>(): "Vault Receiver Reference was not created correctly"
  }
}
