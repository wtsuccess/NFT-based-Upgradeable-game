//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract TestGame is Test {
    Game game;
    address me;

    function setUp() public {
        game = new Game(); // deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84
        uint256 key = 0x1; // setting private key
        me = vm.addr(key); // getting a new signer for the private key
        vm.startPrank(me); // setting this addr as msg.sender from now for every call untill stopPrank is called
    }

    function test_initialize() public {
        game.initialize();
        vm.expectRevert();
        vm.expectRevert();
    }

    function test_owner() public {
        game.initialize();
        assertEq(game.owner(), me);
    }

    function test_baseUri() public {
        game.initialize();
        game.setbaseUri("uri");
        assertEq(game.baseUri(), "uri");
    }

    function test_tokenId() public {
        assertEq(game.tokenId(), 0);
    }

    function test_generateMonster() external {}
}
