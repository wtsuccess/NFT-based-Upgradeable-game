//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract ChooseOpponent is Test {
    address me;
    address opponent;
    Game game;

    function setUp() public {
        game = new Game();
        me = vm.addr(0x1);
        opponent = vm.addr(0x2);
        vm.deal(address(me), 5 ether);
        vm.deal(address(opponent), 5 ether);
    }

    function test_thisFunction() public {
        vm.stopPrank();
        vm.prank(address(opponent));
        game.generateMonster{value: 0.01 ether}();
        vm.startPrank(address(me));
        game.generateMonster{value: 0.01 ether}();
        game.chooseOpponent(1);
    }
}
