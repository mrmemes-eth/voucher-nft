// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@solidstate/token/ERC721/base/ERC721Base.sol";
import "@solidstate/introspection/ERC165/base/ERC165Base.sol";

contract VoucherNFT is ERC721Base, ERC165Base {
    uint256 public _tokenId;
    // tokenId => amount
    mapping(uint256 => uint256) public tokenAmounts;

    function mint(uint256 amount) external payable {
        // check amount sent is equal to amount specified
        require(msg.value == amount, "VoucherNFT: incorrect amount sent");
        // pre-increment the tokenId
        uint256 tokenId;
        unchecked {
            tokenId = ++_tokenId;
        }
        // track amount sent as an attribute associated with the NFT
        tokenAmounts[tokenId] = amount;
        // mint the NFT
        _mint(msg.sender, tokenId);
    }

    function burn(uint256 tokenId) external {
        // check caller is owner of NFT
        require(_ownerOf(tokenId) == msg.sender, "VoucherNFT: caller not owner");
        // burn the NFT
        _burn(tokenId);
        // send the amount associated with the NFT to the caller
        payable(msg.sender).transfer(tokenAmounts[tokenId]);
    }
}
