import FungibleToken from 0x01
import ApprovalVoting from 0x02

// Transaction1.cdc
//
// This transaction allows the administrator of the Voting contract
// to create new proposals for voting and save them to the smart contract

transaction {
    prepare(first: AuthAccount, admin: AuthAccount, third: AuthAccount, fourth: AuthAccount) {
        
        // borrow a reference to the admin Resource
        let adminRef = admin.borrow<&ApprovalVoting.Administrator>(from: /storage/VotingAdmin)!
        
        // Call the initializeProposals function
        // to create the proposals array as an array of strings
        adminRef.initializeProposals(
            ["Longer Shot Clock", "Trampolines instead of hardwood floors"]
        )

        log("Proposals Initialized!")


        
//        let acct1ReceiverRef = acct1.getCapability(/public/MainReceiver)!
//                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()

        // create a new Ballot by calling the issueBallot
        // function of the admin Reference
        var accounts = [first, admin, third, fourth]
        var votes = [0,0,0,1]
        var a = 0
        while a < votes.length {
            let acct = getAccount(accounts[a].address)
            log(acct)
            let acctReceiverRef = acct.getCapability(/public/MainReceiver)!
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct receiver")


            let ballot <- adminRef.issueBallot()
            // Vote on the proposal 
            ballot.vote(proposal: votes[a], token:acctReceiverRef)
            // Cast the vote by submitting it to the smart contract
            ApprovalVoting.cast(ballot: <-ballot)
            a = a+1
        }
        log("Vote cast and tallied")
    }
}
