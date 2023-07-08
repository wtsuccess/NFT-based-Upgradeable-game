// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/MainProxy.sol";
import "../src/Game.sol";

contract ProxyScript is Script {
    function run() external returns (address _address) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        Game game = new Game(); // Deploying the Game contract
        MainProxy proxy =new MainProxy(address(game), abi.encodeWithSignature("initialize()", 0.001 ether));  // Deploying the Proxy contract and making a wrapper on the implementation contract
        _address = address(proxy);
        vm.stopBroadcast();
        return _address;
    }
}
