// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public simpleStorageArray;

    // creates a simple storage contract and adds to array
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();

        simpleStorageArray.push(simpleStorage);
    }

    // stores a fav number for the contract at the specified idx
    function sfStore(uint256 _simpleStorageIdx, uint256 _simpleStorageNumber) public {
        // Address of contract
        // ABI (application binary interface) of contract

        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIdx];

        simpleStorage.store(_simpleStorageNumber);
    }

    // gets the fav number for the contract at the specified idx
    function sfGet(uint256 _simpleStorageIdx) public view returns (uint256) {
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIdx];

        return simpleStorage.retrieve();
    }
}

// Inheritance - StorageFactory inherits from the SimpleStorage contract
// contract StorageFactory is SimpleStorage {
//     SimpleStorage[] public simpleStorageArray;

//     function createSimpleStorageContract() public {
//         SimpleStorage simpleStorage = new SimpleStorage();

//         simpleStorageArray.push(simpleStorage);
//     }

//     function sfStore(uint256 _simpleStorageIdx, uint256 _simpleStorageNumber) public {
//         // Address of contract
//         // ABI (application binary interface) of contract

//         SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIdx];

//         simpleStorage.store(_simpleStorageNumber);
//     }

//     function sfGet(uint256 _simpleStorageIdx) public view returns (uint256) {
//         SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIdx];

//         return simpleStorage.retrieve();
//     }
// }
