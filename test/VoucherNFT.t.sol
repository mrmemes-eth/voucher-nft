// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VoucherNFT} from "../src/VoucherNFT.sol";

contract VouncherNFTTest is Test {
    address minter = address(0xdada);
    address exploiter = address(0xdeadbeef);

    function setUp() public {
        vm.deal(minter, 1000);
    }

    function testMintWithIncorrectAmountSent() public {
        VoucherNFT voucherNFT = new VoucherNFT();
        vm.prank(minter);
        vm.expectRevert("VoucherNFT: incorrect amount sent");
        voucherNFT.mint{value: 99}(100);
        assertEq(voucherNFT._tokenId(), 0);
        assertEq(voucherNFT.balanceOf(minter), 0);
    }

    function testMint() public {
        VoucherNFT voucherNFT = new VoucherNFT();
        vm.prank(minter);
        voucherNFT.mint{value: 100}(100);
        assertEq(voucherNFT._tokenId(), 1);
        assertEq(voucherNFT.tokenAmounts(1), 100);
        assertEq(voucherNFT.balanceOf(minter), 1);
    }

    function testOnlyHolderCanBurn() public {
        VoucherNFT voucherNFT = new VoucherNFT();
        vm.prank(minter);
        voucherNFT.mint{value: 100}(100);
        assertEq(voucherNFT._tokenId(), 1);
        assertEq(voucherNFT.tokenAmounts(1), 100);
        assertEq(voucherNFT.balanceOf(minter), 1);
        vm.expectRevert("VoucherNFT: caller not owner");
        voucherNFT.burn(1);
    }

    function testBurn() public {
        VoucherNFT voucherNFT = new VoucherNFT();
        vm.prank(minter);
        voucherNFT.mint{value: 100}(100);
        assertEq(payable(minter).balance, 900);
        assertEq(voucherNFT._tokenId(), 1);
        assertEq(voucherNFT.tokenAmounts(1), 100);
        assertEq(voucherNFT.balanceOf(minter), 1);
        vm.prank(minter);
        voucherNFT.burn(1);
        assertEq(voucherNFT.balanceOf(minter), 0);
        assertEq(payable(minter).balance, 1000);
    }

    function testOnlyHolderCanTransfer() public {
        VoucherNFT voucherNFT = new VoucherNFT();
        vm.prank(minter);
        voucherNFT.mint{value: 100}(100);
        assertEq(voucherNFT._tokenId(), 1);
        assertEq(voucherNFT.tokenAmounts(1), 100);
        assertEq(voucherNFT.balanceOf(minter), 1);
        // IERC721BaseInternal.ERC721Base__NotOwnerOrApproved();
        vm.prank(exploiter);
        vm.expectRevert(0x2f5de44f);
        voucherNFT.transferFrom(minter, exploiter, 1);
    }
}
