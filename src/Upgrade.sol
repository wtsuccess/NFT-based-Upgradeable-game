//SPDX-License-Identofier: MIT
pragma solidity ^0.8.17;
import "./Game.sol";

contract Upgrade is Game {
    function getGreetings() public pure returns(string memory){
        return "You are doing well!";
    }
}

// https://sepolia.etherscan.io/address/0x4576ae4df49ab83ff674fcdc2f133ecb755e063c