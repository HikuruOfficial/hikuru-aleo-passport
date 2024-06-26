[![Follow us on Twitter](https://img.shields.io/twitter/follow/HikuruOfficial?style=social&logo=twitter)](https://twitter.com/HikuruOfficial)
[![Join our Discord](https://img.shields.io/discord/989643607898206208?color=%237289DA&label=Join%20our%20Discord&logo=discord&logoColor=white)](https://discord.gg/mevde2mRSw)
![Aleo Badge](https://img.shields.io/badge/Aleo-Developer-1572B6?style=flat-square&logo=aleo&logoColor=white)
[![License](https://img.shields.io/badge/license-MIT-orange.svg)](https://opensource.org/licenses/MIT)


# What is Hikuru Passport?

Hikuru Passport (Aleo blockchain) is a digital ID that uses valid credentials to verify user activity. It does not store personal information and ensures user privacy. It also uses on-chain analysis to verify the wallet on different blockchains, which increases the reliability and security of the system. Its use can help reduce fraudulent activities and provide more accurate user identification on the blockchain. Any project will be able to add wallet discovery function using our passport.

### Deployed contract
[hikuru_passport_v1.aleo](https://explorer.hamp.app/program?id=hikuru_passport_v1.aleo)

## How we convert string to field?

At the moment of script development there is no method for storing strings, so I had to invent my own. I invented to replace the text with capital letters so as not to go beyond the range of two-digit numbers and replace them with ascii code for each letter.


```
function stringToFields(inputString) {
  let numericSequence = "";
  inputString=inputString.toUpperCase();
  for (let i = 0; i < inputString.length; i++) {
    const charCode = inputString.charCodeAt(i);
    numericSequence += charCode.toString();
  }
  return numericSequence+"field";
}
```


## Features

### 1. Minting NFTs

The contract provides a function to mint a new NFT for a user. The `mint` function allows the owner to create a unique NFT associated with their identity. It requires the following input parameters:

- `passport_owner`: The address of the NFT owner.
- `username`: The username of the user.
- `edition`: NFT user version
- `time`: The time when passport was created.
- `scores`: The score of the user based on their blockchain and social media activities.

  
Example usage of the `mint` function:
```
mint(
  username: UserName = UserName { data0: 129134456695144u128, data1: 0u128, data2: 0u128, data3: 0u128 };
  tokenid: TokenId = TokenId { data1: 1u128, data2: 0u128 };
  edition: scalar = 1scalar;
  time: u64 = 1688310041u64;
  scores: u32 = 80u32;
)
```

### 2. Updating NFTs

The contract allows users to update their existing NFTs using the `update_nft` function. This function enables users to modify their NFT's associated information, such as the username, IPFS hash, timestamp, and scores. It requires the following input parameters:

- `passport_owner`: The address of the NFT owner.
- `username`: The username of the user.
- `edition`: NFT user version
- `time`: The time when passport was created.
- `scores`: The score of the user based on their blockchain and social media activities.

Example usage of the `update_nft` function:
```
update_nft(
owner: address = aleo1593eszedn3kp4ansaw7vrruqym6tqcywtc2ly5yq5gd2gg9d5qpq5hf26k;
username: UserName = UserName { data0: 1u128, data1: 0u128, data2: 0u128, data3: 0u128 };
edition: scalar = 2scalar;
time: u64 = 1688310041u64;
scores: u32 = 82u32;
)
```

### 3. User Status Calculation

The contract includes a function called `get_status` to calculate the status of a user based on their score. The status determines whether the user is classified as a Sybil, Human, or Crypto Enthusiast. The scoring ranges for each status are as follows:

- Sybil: Scores from 0 to 20
- Human: Scores from 21 to 79
- Crypto Enthusiast: Scores from 80 to 100

### 4. Storage and Mapping

The contract utilizes a `mapping` data structure to store NFTs associated with their respective owners. The `identity` mapping is used to associate an address with an NFT struct.

### 5. Unique NFT Ownership

Each NFT created using the contract is unique and cannot be transferred to another user. The contract enforces this uniqueness to ensure that each identity remains exclusive to its owner, mimicking the real-life scenario where identity cannot be transferred.

## Scoring Mechanisms

The contract incorporates scoring mechanisms to assess users' activities on various blockchain networks and social media platforms. The scoring is performed as follows:

### Aleo Blockchain
- Transaction older than 30 days: 4 points
- More than 10 transactions: 6 points
- More than 50 transactions: 10 points

### Ethereum
- Transaction older than 30 days: 4 points
- More than 10 transactions: 6 points
- More than 50 transactions: 10 points

### Binance Smart Chain
- Transaction older than 30 days: 4 points
- More than 10 transactions: 6 points
- More than 50 transactions: 10 points

### Polygon
- Transaction older than 30 days: 4 points
- More than 10 transactions: 6 points
- More than 50 transactions: 10 points

### NFT Holder
- NFT holder on Aleo: 2 points
- Domain Aleo: 2 points

### Social Network
- Discord: 2 points
- Twitter: 2 points
- Twitter followers (100+): 5 points
- GitHub: 2 points
- GitHub repository: 5 points

## Example Data

Here are example input data for the correct usage of the contract's functions:

### Mint Function
```
[mint]
username: UserName = UserName { data0: 129134456695144u128, data1: 0u128, data2: 0u128, data3: 0u128 };
tokenid: TokenId = TokenId { data1: 1u128, data2: 0u128 };
edition: scalar = 1scalar;
time: u64 = 1688310041u64;
scores: u32 = 80u32;

```

### Update NFT Function
```
[update_nft]
owner: address = aleo1593eszedn3kp4ansaw7vrruqym6tqcywtc2ly5yq5gd2gg9d5qpq5hf26k;
username: UserName = UserName { data0: 1u128, data1: 0u128, data2: 0u128, data3: 0u128 };
edition: scalar = 2scalar;
time: u64 = 1688310041u64;
scores: u32 = 82u32;
```


Please note that the above data examples serve as a reference for correctly invoking the contract's functions with appropriate input parameters.

---

This README file provides a comprehensive overview of the Hikuru NFT contract, its features, and the scoring mechanisms incorporated to assess user activities. Use this guide to understand the contract's functionality and leverage it as a professional developer.
