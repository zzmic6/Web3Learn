// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

contract Require1 {
   
   address private owner;

    constructor() {
        owner = msg.sender;
    }

    function mint() external {
        require(msg.sender == owner, "Only the owner can call this function.");
        // Function code goes here
    }

    function changeOwner() external {
        require(msg.sender == owner, "Only the owner can call this function.");
        // Function code goes here
    }

    function pause() external {
        require(msg.sender == owner, "Only the owner can call this function.");
        // Function code goes here
    }

}