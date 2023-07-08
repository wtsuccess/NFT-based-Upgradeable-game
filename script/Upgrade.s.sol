//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/Upgrade.sol";

contract UpgradeScript is Script {
    function run() public {
         uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        Upgrade upgrade = new Upgrade();
        vm.stopBroadcast();
        
    }
}

