//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";
import "../src/MainProxy.sol";

contract ProxyTest is Test {
    address me;
    Game game;
    MainProxy mainProxy;
    Upgraded upgraded;

    function setUp() public {
        me = vm.addr(0x1);
        vm.deal(address(me), 5 ether);
        vm.startPrank(address(me));
        address gameImplementation = address(new Game());
        console.log("game implementation address:", gameImplementation);
        mainProxy = new MainProxy(
            gameImplementation,
            abi.encodeWithSignature("initialize()", 0.001 ether)
        );
        console.log("mainProxy address:", address(mainProxy));
        game = Game(address(mainProxy));
        console.log("game address:", address(game));
        upgraded = new Upgraded();
        console.log("address of Upgraded:", address(upgraded));
    }

    function test_proxy() public {
        assertEq(game.monsterId(), 0);
        // game.initialize();
        game.upgradeTo(address(upgraded));
        game.generateMonster{value: 0.01 ether}();
        assertEq(game.monsterId(), 1);
        // assertEq(game.getGreetings(),"You are doing well!");
    }
}

contract Upgraded is Game {
    function getGreetings() public pure returns (string memory) {
        return "You are doing well!";
    }
}
