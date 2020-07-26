// Script1.cdc

import FungibleToken from 0x01 
import ApprovalVoting from 0x02
// This script reads the Vault balances of two accounts.
pub fun main() {
    // Get the accounts' public account objects
    let acct1 = getAccount(0x01)
    let acct2 = getAccount(0x02)
    let acct3 = getAccount(0x03)
    let acct4 = getAccount(0x04)

    // Get references to the account's receivers
    // by getting their public capability
    // and borrowing a reference from the capability
    let acct1ReceiverRef = acct1.getCapability(/public/MainReceiver)!
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct1 receiver")
    let acct2ReceiverRef = acct2.getCapability(/public/MainReceiver)!
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct2 receiver")
    let acct3ReceiverRef = acct3.getCapability(/public/MainReceiver)!
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct3 receiver")
    let acct4ReceiverRef = acct4.getCapability(/public/MainReceiver)!
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct4 receiver")

    // Use optional chaining to read and log balance fields
    log("Account 1 Balance")
	log(acct1ReceiverRef.balance)
    log("Account 2 Balance")
    log(acct2ReceiverRef.balance)
    log("Account 3 Balance")
	log(acct3ReceiverRef.balance)
    log("Account 4 Balance")
    log(acct4ReceiverRef.balance)

    log("Number of Votes for Proposal 1:")
    log(ApprovalVoting.proposals[0])
    log(ApprovalVoting.votes[0])

    log("Number of Votes for Proposal 2:")
    log(ApprovalVoting.proposals[1])
    log(ApprovalVoting.votes[1])


}
