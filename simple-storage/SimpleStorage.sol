// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {
    uint256 someNum; // initialized to 0

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public people;

    mapping(string => uint256) public nameToFavNum;

    function store(uint256 _someNum) public {
        someNum = _someNum;
    }

    // view function for viewing data, does not initiate a transaction
    function retrieve() public view returns (uint256) {
        return someNum;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        Person memory newPerson = Person({
            name: _name,
            favoriteNumber: _favoriteNumber
        });

        people.push(newPerson);

        nameToFavNum[_name] = _favoriteNumber;
    }
}
