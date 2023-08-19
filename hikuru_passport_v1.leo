// Created by Hikuru

program hikuru_passport_v1.aleo{
   
    // keys: just two, 0u8 which corresponds to different on/off settings for the contract, and 1u8
    // which corresponds to the mint block height.
    // values: the bitstring that represents the settings that can be toggled
    // in order of least significant bit index to most significant bit:
    // 0: collection has been initialized
    // 1: can minters mint
    // 2: do minters have to have a mint record (i.e. is the private whitelist a requirement)
    // 3: is the collection frozen
    mapping toggle_settings: u8 => u32;
    // values: setting value
    mapping general_settings: u8 => u128;

    
    // The token id is a 256 bit number that is the unique identifier for the NFT.
    struct TokenId {
        data1: u128, 
        data2: u128,
    }
  
    // base uri ascii bits. Include as many data pieces as necessary to encapsulate the uri. Padded with 0s at the end.
    struct BaseURI {
        data0: u128, // Part 1 of the base uri in bits. Bits should be the representation of the hexadecimal bytes for the ASCII text of the URL
        data1: u128,
        data2: u128,
        data3: u128
    }
  
    // The username is ascii text represented in bits, and the u128 value of the bitstring.
    struct UserName {
        data0: u128, 
        data1: u128,
        data2: u128,
        data3: u128
    }
    
    // The sybmol's ascii text represented in bits, and the u128 value of the bitstring.
    struct SymbolBits {
        data: u128 
    }
  

    struct PassPort {
        passport_owner: address,
        username: UserName,
        time: u64,
        scores: u32, // The score of the user
        status: u32  // The status of the user: 0 = Sibyl, 1 = Human, 2 = Crypto Enthusiast.
                     // 0 - 20 = Sibyl
                     // 21 - 79 = Human
                     // 80 - 100 = Crypto Enthusiast
    }


    record NFT {
        private owner: address,
        private data: TokenId,
        private edition: scalar, // which edition of the nft this particular one is -- will be 0 for unique NFTs
        private passport: PassPort
    }

    
    mapping identity:  address =>  PassPort;
    mapping identity_via_username: UserName => PassPort;
  
  
    // Calculate the status of the user based on the score
    function get_status(score: u32) -> u32 {
        // 0 - 20
        if score.lte(20u32){
            return 0u32;
        // 21 - 79
        } else if score.lt(80u32){
            return 1u32;
        // 80 - 100
        } else {
            return 2u32;
        }
    }
  
  
    // Initialize the collection - can only be called once by the owner of the contract
    transition initialize_collection(
        public total: u128,
        public symbol: u128,
        public base_uri: BaseURI,
    ) {
        assert_eq(self.caller, aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl);
        return then finalize(total, symbol, base_uri);
    }
  
    finalize initialize_collection(
        public total: u128,
        public symbol: u128,
        public base_uri: BaseURI,
    ) {
        // Ensure initialize cannot be called twice!
        let is_initialized: u32 = toggle_settings.get_or_use(0u8, 0u32);
        assert_eq(is_initialized, 0u32);
  
        general_settings.set(0u8, 0u128); // number of mintable NFTs (all editions)
        general_settings.set(1u8, total); // Number of total NFTs (first-editions) that can be minted
        general_settings.set(2u8, symbol); // Symbol for the NFT
        general_settings.set(3u8, base_uri.data0); // Base URI for NFT
        general_settings.set(4u8, base_uri.data1);
        general_settings.set(5u8, base_uri.data2);
        general_settings.set(6u8, base_uri.data3);
        toggle_settings.set(0u8, 5u32);
        toggle_settings.set(1u8, 0u32); // block height when mint is allowed
    }

    // Update the base uri for the NFTs
    transition update_base_uri(public base_uri: BaseURI) {
        assert_eq(self.caller, aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl);
        return then finalize(base_uri);
    }

    finalize update_base_uri(public base_uri: BaseURI) {
       // Ensure collection is initialized and not frozen.
        let is_initialized_and_not_frozen: u32 = toggle_settings.get_or_use(0u8, 1u32);
        assert_eq(is_initialized_and_not_frozen, 1u32);

        general_settings.set(3u8, base_uri.data0); // Base URI for NFT
        general_settings.set(4u8, base_uri.data1);
        general_settings.set(5u8, base_uri.data2);
        general_settings.set(6u8, base_uri.data3);
    }


    
    // Mint a new NFT for the user
    transition mint(
      public username: UserName,
      public tokenid: TokenId,
      public edition: scalar,
      public time: u64,
      public scores: u32
      ) -> NFT {
        let status: u32 = get_status(scores);

        // Create a new passport for the user
        let passport: PassPort = PassPort {
            passport_owner: self.caller,
            username: username,
            time: time,
            scores: scores, // The score of the user
            status: status
        };


        // Return a new record for the passport.
        // Finalize the proposal id.
          return NFT {
            owner: self.caller,
            data: tokenid,
            edition: edition,
            passport: passport
          } then finalize(self.caller, username, passport);
    }
  
    finalize mint(owner: address, username: UserName, passport: PassPort) {

        // if owner or username already exists, throw error
        let owner_exists: u64 = Mapping::get(identity, owner).time | 0u64;
        let username_exists: u64 = Mapping::get(identity_via_username, username).time | 0u64;

        assert_eq(owner_exists, 0u64);      // if owner already exists, throw error
        assert_eq(username_exists, 0u64);   // if username already exists, throw error


        let is_initialized: u32 = toggle_settings.get_or_use(0u8, 0u32);
        assert_neq(is_initialized, 0u32);
        // Store the NFT in the mapping
        Mapping::set(identity, owner, passport);
        Mapping::set(identity_via_username, username, passport);

    }
  
  
    //Update the NFT of the user
    transition update_passport(owner: address, username: UserName, edition: scalar, time: u64, scores: u32) {
        assert_eq(owner, self.caller); //only owner can update his NFT


        let status: u32 = get_status(scores); // calculate the status of the user
        return then finalize(owner, username, edition, scores, status);
    }
  
    finalize update_passport(owner: address, username: UserName, edition: scalar, scores: u32, status: u32) {
        // Check if the user already has a passport if not throw error
        let owner_exists: u64 = Mapping::get(identity, owner).time | 0u64;
        let username_exists: u64 = Mapping::get(identity_via_username, username).time | 0u64;

        assert_eq(owner_exists, 0u64);      // if owner already exists, throw error
        assert_eq(username_exists, 0u64);   // if username already exists, throw error


        let old_nft:PassPort = Mapping::get(identity, owner);


        let new_passport:PassPort = PassPort {
            passport_owner: old_nft.passport_owner,
            username: username,
            time: old_nft.time,
            scores: scores, // The score of the user
            status: status
        };
  
        let is_initialized: u32 = toggle_settings.get_or_use(0u8, 0u32);
        assert_neq(is_initialized, 0u32);
        // Store the NFT in the mapping
        Mapping::set(identity, owner, new_passport);
        Mapping::set(identity_via_username, username, new_passport);
    }
  
  
  
    // User cant transfer NFT to another user, because it is unique.
    // As in real life, you can't transfer your identity to another person.
  }

  // Offical Hikuru PassPort NFT - https://hikuru.com 