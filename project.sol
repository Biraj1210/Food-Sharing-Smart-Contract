// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FoodSharingPlatform {
    struct FoodItem {
        uint id;
        string name;
        string description;
        address donor;
        bool isClaimed;
    }
    
    mapping(uint => FoodItem) public foodItems;
    mapping(address => uint) public tokenBalance;
    uint public foodCount;
    uint public constant TOKEN_REWARD = 10;
    
    event FoodAdded(uint id, string name, address indexed donor);
    event FoodClaimed(uint id, address indexed claimer);
    event TokensTransferred(address from, address to, uint amount);
    
    function addFood(string memory _name, string memory _description) public {
        foodCount++;
        foodItems[foodCount] = FoodItem(foodCount, _name, _description, msg.sender, false);
        tokenBalance[msg.sender] += TOKEN_REWARD;
        emit FoodAdded(foodCount, _name, msg.sender);
    }
    
    function claimFood(uint _id) public {
        require(_id > 0 && _id <= foodCount, "Invalid food ID");
        require(!foodItems[_id].isClaimed, "Food already claimed");
        
        foodItems[_id].isClaimed = true;
        emit FoodClaimed(_id, msg.sender);
    }
    
    function transferTokens(address _to, uint _amount) public {
        require(tokenBalance[msg.sender] >= _amount, "Insufficient tokens");
        
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
        emit TokensTransferred(msg.sender, _to, _amount);
    }
}
