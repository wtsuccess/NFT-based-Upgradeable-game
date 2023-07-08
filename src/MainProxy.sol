//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "contracts/Proxy.sol";
import "contracts/ERC1967/ERC1967Upgrade.sol";

contract MainProxy is Proxy, ERC1967Upgrade {
    constructor(address _logic, bytes memory _data) payable {
        _upgradeToAndCall(_logic, _data, false);
    }

    function _implementation()
        internal
        view
        virtual
        override
        returns (address impl)
    {
        return ERC1967Upgrade._getImplementation();
    }
}

// https://sepolia.etherscan.io/address/0x6fcc6eb7f78cf146a4abeed5aa8b8260ca115b6c
// The first contract is a simple wrapper or "proxy" which users interact with directly and is in charge of forwarding transactions to and from the second contract, which contains the logic.
