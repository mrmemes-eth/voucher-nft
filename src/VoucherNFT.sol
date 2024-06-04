// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC165Base} from "@solidstate/introspection/ERC165/base/ERC165Base.sol";
import {ERC721Base, ERC721BaseInternal} from "@solidstate/token/ERC721/base/ERC721Base.sol";
import {ERC721MetadataStorage} from "@solidstate/token/ERC721/metadata/ERC721MetadataStorage.sol";
import {ERC721Metadata} from "@solidstate/token/ERC721/metadata/ERC721Metadata.sol";

contract VoucherNFT is ERC721Base, ERC165Base, ERC721Metadata {
    uint256 public _tokenId;
    // tokenId => amount
    mapping(uint256 => uint256) public tokenAmounts;

    constructor() {
        ERC721MetadataStorage.Layout storage l = ERC721MetadataStorage.layout();
        l.name = "VoucherNFT";
        l.symbol = "VNFT";
        l.baseURI = "ipfs://QmQvNWmRMvz9CbYZsgbcz9kGWcFU3Ho5SpP2MFmoCSMLHi?tokenId=";
    }

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

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721Metadata, ERC721BaseInternal)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
