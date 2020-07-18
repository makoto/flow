pub contract GiveMe1000GiveYou2000Token {
  pub resource NFT{
    pub let id: UInt64
    pub var metadata: {String: String}
    init(initID:UInt64){
      self.id = initID
      self.metadata = {}
    }
  }

  init(){
    self.account.save<@NFT>(<-create NFT(initID:1), to: /storage/NFT1)
  }
}
