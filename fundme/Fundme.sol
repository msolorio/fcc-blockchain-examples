// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

// Pulls in Aggregator interface for fetching price data
// https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
import '@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol';

contract FundMe {
    // Creates mapping between addresses and an integer value
    mapping(address => uint256) public addressToAmountFunded;
    
    address[] public funders;
    
    // converting USD amount to 8 extra decimal places (solidity doesn't allow for floating points)
    uint256 public minimumUsd = 50 * 10**8;
    uint256 public value;
    address public owner;
    
    // constructor is called only once when contract is created.
    // At that time msg.sender will be my account, setting my account as owner
    constructor() public {
        owner = msg.sender;
    }
    
    function returnValue() public payable returns (uint256) {
        value = msg.value;
    }
    
    // adds the address of sender and the value sent to the mapping created above
    function fund() public payable {
        
        // Taking passed in value, converting to USD, and checking if meets minimum USD.
        require(getConversionRate(msg.value) >= minimumUsd, 'You need to spend more eth');
        
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    // account sending message must be owner (creator) of the contract
    modifier onlyOwner {
        require(msg.sender == owner, 'You are not the owner of this contract');
        _; // continues running the parent function (withdraw)
    }
    
    // account making withdraw must be owner
    function withdraw() payable onlyOwner public {
        // this refers to current contract
        // address(this) will return the current address
        // .balance will get the balance of that address
        
        // Gets the total balance of this address (this contract instance)
        uint totalBalance = address(this).balance;
        
        // transfers the total balance to the message sender (the owner).
        msg.sender.transfer(totalBalance);
        
        // resets all accounts to 0
        for (uint256 funderIdx = 0; funderIdx < funders.length; funderIdx++) {
            address funder = funders[funderIdx];
            addressToAmountFunded[funder] = 0;
        }
        
        // resets funders to empty address array with 0 items
        funders = new address[](0);
    }
    
    function getVersion() public view returns (uint256) {
        // Grabs the interface located at the specified address for ETH -> USD
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        
        return priceFeed.version();
    }
    
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

        // gets price in eth with 8 extra decimal places added
        (,int256 answer,,,) = priceFeed.latestRoundData();
        
        return uint256(answer);
    }
    
    
    
    // Takes in eth amount and converts to USD with 8 extra decimal places added (solidity doesn't allow for floating points)
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / (10**18);
        return ethAmountInUsd;
    }
}