//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract GenerateMonster is Test {
    address me;
    address me2;
    Game game;

    function setUp() public {
        game = new Game();
        uint256 key = 0x1;
        me = vm.addr(key);
        me2 = vm.addr(0x2);
        vm.startPrank(me);
        vm.deal(me, 5 ether); // to fund a address
    }

    function test_payableWithGreter() public {
        vm.expectRevert(); // This expects an error on next call, so use it before
        game.generateMonster{value: 1 ether}();
    }

    function test_payableWithLower() public {
        vm.expectRevert();
        game.generateMonster{value: 0 ether}();
    }

    function test_incrementMonsterId() public {
        assertEq(game.addressToMonsterId(address(me)), 0);
        game.generateMonster{value: 0.01 ether}();
        assertEq(game.monsterId(), 1);
        assertEq(game.monsterIdToAddress(1), address(me));
        assertEq(game.presentInMonsters(1), true);
        assertEq(game.monsterReadyToAttack(1), true);
    }
}
