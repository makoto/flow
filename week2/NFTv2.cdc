// Kitties go brrrrrrr Token.
// Send me 1000 kitties, I will return 2000 kitties (NOTE, the emulator dies if you try to put more than 6 kitties though).

pub contract GiveMe1000GiveYou2000Token {

    // Declare the NFT resource type
    pub resource NFT {
        // The unique ID that differentiates each NFT
        pub let id: UInt64
        pub let face: String

        // Initialize both fields in the init function
        init(initID: UInt64) {
            self.id = initID
            var faces:[String] = ["\u{1F431}", "\u{1F63A}", "\u{1F63B}", "\u{1F63C}", "\u{1F63D}"]
            var faceType = Int(initID) % faces.length
            self.face = faces[faceType]
        }
    }

    // We define this interface purely as a way to allow users
    // to create public, restricted references to their NFT Collection.
    // They would use this to only expose the deposit, getIDs,
    // and idExists fields in their Collection
    pub resource interface NFTReceiver {

        pub fun deposit(token: @NFT)

        pub fun getIDs(): [UInt64]

        pub fun idExists(id: UInt64): Bool
    }

    // The definition of the Collection resource that
    // holds the NFTs that a user owns
    pub resource Collection: NFTReceiver {
        // dictionary of NFT conforming tokens
        // NFT is a resource type with an `UInt64` ID field
        pub var ownedNFTs: @{UInt64: NFT}

        // Initialize the NFTs field to an empty collection
        init () {
            self.ownedNFTs <- {}
        }

        // withdraw 
        //
        // Function that removes an NFT from the collection 
        // and moves it to the calling context
        pub fun withdraw(withdrawID: UInt64): @NFT? {
            if let token <- self.ownedNFTs.remove(key: withdrawID) {
                return <- token
            }

            return nil
        }

        // deposit 
        //
        // Function that takes a NFT as an argument and 
        // adds it to the collections dictionary
        pub fun deposit(token: @NFT) {
            // add the new token to the dictionary which removes the old one
            let oldToken <- self.ownedNFTs[token.id] <- token
            destroy oldToken
        }

        // idExists checks to see if a NFT 
        // with the given ID exists in the collection
        pub fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    // creates a new empty Collection resource and returns it 
    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    // NFTMinter
    //
    // Resource that would be owned by an admin or by a smart contract 
    // that allows them to mint new NFTs when needed
    pub resource NFTMinter {

        // the ID that is used to mint NFTs
        // it is onlt incremented so that NFT ids remain
        // unique. It also keeps track of the total number of NFTs
        // in existence
        pub var idCount: UInt64

        init() {
            self.idCount = 0
        }

        // mintNFT 
        //
        // Function that mints a new NFT with a new ID
        // and deposits it in the recipients collection 
        // using their collection reference
        pub fun mintNFT(nfts: &Collection, recipient: &AnyResource{NFTReceiver}): [Int] {
            var a = 0
            var ids: [UInt64] = nfts.getIDs()
            var nftLength = ids.length

            var newIds: [Int] = []
            if nftLength == 0 {
                // create a new NFT
                self.idCount = self.idCount + UInt64(1)
                var newNFT <- create NFT(initID: self.idCount)
                recipient.deposit(token: <-newNFT)
                return [Int(self.idCount)]
            }

            while a < nftLength {
                // create a new NFT
                self.idCount = self.idCount + UInt64(1)
                var newNFT <- create NFT(initID: self.idCount)
                // deposit it in the recipient's account using their reference
                recipient.deposit(token: <- newNFT)
                if let token <- nfts.withdraw(withdrawID: ids[a]){
                    recipient.deposit(token: <- token )
                }
                newIds.append(Int(self.idCount))
                newIds.append(Int(ids[a]))
                a = a + 1
            }
            return newIds
        }
    }

	init() {
		// store an empty NFT Collection in account storage
        self.account.save(<-self.createEmptyCollection(), to: /storage/NFTCollection)

        // publish a reference to the Collection in storage
        self.account.link<&{NFTReceiver}>(/public/NFTReceiver, target: /storage/NFTCollection)

        // store a minter resource in account storage
        self.account.save(<-create NFTMinter(), to: /storage/NFTMinter)
	}
}
 