// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract Attack is Test {
    Game game;
    address me;
    address opponent;
    function setUp() public {
        game = new Game();
        me = vm.addr(0x1);
        opponent = vm.addr(0x2);
        vm.deal(address(me), 5 ether);
        vm.deal(address(opponent), 5 ether);
        vm.prank(address(opponent));
        game.generateMonster{value: 0.01 ether}();
        vm.startPrank(address(me));
        game.generateMonster{value: 0.01 ether}();
    }

    function test_Attack() public {
        assertEq(game.addressToMonsterId(address(opponent)), 1);
        assertEq(game.addressToMonsterId(address(me)), 2);
        game.chooseOpponent(1);
       // game.attack{value: 0.01 ether}(1);
        assertEq(game.balanceOf(address(me)), 1);
        assertEq(game.balanceOf(address(opponent)), 1);
    }


}