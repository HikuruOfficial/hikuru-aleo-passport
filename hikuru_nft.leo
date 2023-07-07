
program hikuru_nft.aleo{
    // This program is a simple NFT contract that allows the owner to mint a new NFT,
    // Store Username and Password Score, which confirm that is real user.

    // Aleo blockchain transaction section
    // 1 Transaction in Aleo more than 30 days ago - 5 points.
    // 2. more than 10 transactions in Aleo - 3 points.
    // 3. more than 50 transactions in Aleo - 10 points.

    // Ethereum section
    // 1. More than 30 days previous transaction in ethereum - 5 points
    // 2. more than 10 transactions in ETH - 3 points.
    // 3. more than 50 transactions in ETH - 10 points.

    // Binance Smart Chain section
    // 1. more than 30 days previous transaction - 5 points.
    // 2. more than 10 transactions - 3 points.
    // 3. more than 50 transactions - 10 points.

    // Polygon 
    // 1. more than 30 days ago - 5 points.
    // 2. more than 10 transactions - 3 points.
    // 3. more than 50 transactions - 10 points.

    // NFT Holder
    // 1. NFT holder in Aleo - 4 points 
    // 2. NFT holder on air - 4 points.

    // Social Network

    // Discord Score = 2 points
    // Twitter Score = 2 points.
    // 100 Followers Twitter + 5 points.
    // Telegram Score = 2
    // Github Score = 2.
    // Repository + 5 points
    // Reddit Score = 2.


    struct NFT{
        identity_onwer: address,     // The owner of the NFT
        gates: u64,         // Required gates parameter 
        username: field,    // The username of the user
        ipfs: field,        // The IPFS hash of the user
        time: u64,          // The time when the user minted the NFT or updated it
        scores: u32,        // The score of the user
        status: u32,        // The status of the user: 0 = Sibyl, 1 = Human, 2 = Crypto Enthusiast.
        // 0 - 20 = Sibyl
        // 21 - 79 = Human
        // 80 - 100 = Crypto Enthusiast
    }



    mapping identity:  address => NFT;


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


    // Mint a new NFT for the user
    transition mint (owner: address, username: field, ipfs: field, time: u64, scores: u32) -> NFT {
        let status: u32 = get_status(scores);

        let nft:NFT = NFT{
            identity_onwer: owner,
            gates: 0u64,
            username: username,
            ipfs: ipfs,
            time: time,
            scores: scores,
            status: status,
        };

        return nft then finalize(nft);
    }

    finalize mint(nft: NFT) {
        // Store the NFT in the mapping
        Mapping::set(identity, nft.identity_onwer, nft);
    }


    //Update the NFT of the user
    transition update_nft(owner: address, username: field, ipfs: field, time: u64, scores: u32) {
        let status: u32 = get_status(scores);
        return then finalize(owner, username, ipfs, time, scores, status);
    }

    finalize update_nft(owner: address, username: field, ipfs: field, time: u64, scores: u32, status: u32) {
        let nft:NFT = Mapping::get(identity, owner);

        let new_nft:NFT = NFT{
            identity_onwer: owner,
            gates: nft.gates,
            username: username,
            ipfs: ipfs,
            time: time,
            scores: scores,
            status: status
        };

        // Store the NFT in the mapping
        Mapping::set(identity, owner, new_nft);
    }


    //check is user has NFT
    // transition is_owner (owner: address) ->  {
        
    // }



    // User cant transfer NFT to another user, because it is unique.
    // As in real life, you can't transfer your identity to another person.
}