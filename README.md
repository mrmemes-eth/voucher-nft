## VoucherNFT

### Description

This project is a smart contract implementation of a Voucher NFT (Non-Fungible Token). It is built using Solidity and utilizes the ERC721 and ERC165 standards.

### Features

- Minting: Users can mint Voucher NFTs by sending a specified amount of Ether to the contract.
- Burning: Owners of Voucher NFTs can burn their tokens to receive the associated amount of Ether.
- Transfer: Voucher NFTs can be transferred between different addresses.

### Usage

To use this project, follow these steps:

1. Deploy the VoucherNFT contract to a compatible Ethereum network.
2. Interact with the contract using the provided functions, such as `mint`, `burn`, and `transferFrom`.

### Deploying

This was a quick project for the Base developer quest. If you're keen to deploy it for that as well, here's my `forge` deploy invocation:

```shell
forge create src/VoucherNFT.sol:VoucherNFT \
  -r https://goerli.base.org \
  -c 84531 \
  --verify \
  --verifier-url https://api-goerli.basescan.org/api \
  -e $BASESCAN_API_KEY \
  -i 
```

That'll prompt you for the private key of your deployer interactively. GLHF!

### Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

### License

This project is licensed under the MIT License.
