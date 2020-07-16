import FungibleToken from 0x01cf0e2f2f715450


pub fun main(){
  let acct1 = getAccount(0x01cf0e2f2f715450)
  let acct2 = getAccount(0x179b6b1cb6755e31)
  let acct1ReceiverRef = acct1.getCapability(/public/MainReceiver)!
                              .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()!
  let acct2ReceiverRef = acct2.getCapability(/public/MainReceiver)!
                              .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()!
  log("Account 1 Balance")
  log(acct1ReceiverRef.balance)
  log("Account 2 Balance")
  log(acct2ReceiverRef.balance)
}

// import FungibleToken from 0x01cf0e2f2f715450 

// // This script reads the Vault balances of two accounts.
// pub fun main() {
//   // Get the accounts' public account objects
//   let acct1 = getAccount(0x01cf0e2f2f715450)
//   let acct2 = getAccount(0x179b6b1cb6755e31)

//   // Get references to the account's receivers
//   // by getting their public capability
//   // and borrowing a reference from the capability
//   let acct1ReceiverRef = acct1.getCapability(/public/MainReceiver)!
//                           .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()!
//   let acct2ReceiverRef = acct2.getCapability(/public/MainReceiver)!
//                                                 .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()!

//   // Read and log balance fields
//   log("Account 1 Balance")
//     log(acct1ReceiverRef.balance)
//   log("Account 2 Balance")
//   log(acct2ReceiverRef.balance)
// }