// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

error Storage_Not_owner();

error Withdraw_Fail();

contract StorageMoney is ERC20 {
    address[] private s_users;

    mapping(address => bool) private s_hasAddress;

    mapping(address => uint256) private s_userFundaton;

    address public immutable i_owner;

    event Withdraw_info(address from,address to ,uint value);

    //contract status;
    bool private status;

    constructor(uint256 initCapacity) ERC20("GOLD", "GLD") {
        i_owner = msg.sender;
        _mint(i_owner, initCapacity);
        status = true;
    }

    /**
     *  going to fund;
     */
    function fund() public payable isActive {
        uint256 value = msg.value;
        require(value > 0, "current value can not be 0");
        address fromAddress = msg.sender;
        if (!s_hasAddress[fromAddress]) {
            s_hasAddress[fromAddress] = true;
            s_userFundaton[fromAddress] = value;
            s_users.push(fromAddress);
        } else {
            s_userFundaton[fromAddress] += value;
        }
        transfer(address(this), value);
    }

    /**
     * withdraw
     *desc: it will be close when it perform withdraw,and send balance to owner.
     */
    function withdraw() public  isActive isOwner {
        uint256 balance = address(this).balance;

        if (balance <= 0) {
            status = false;
            return;
        }
         (bool success,)= payable(i_owner).call{value:address(this).balance}("");
        if (!success){
           revert Withdraw_Fail();
        }

        for (uint256 i = 0; i < s_users.length; i++) {
            address addr = s_users[i];
            s_hasAddress[addr] = false;
            s_userFundaton[addr] = 0;
            s_users[i] = s_users[s_users.length - 1];
            s_users.pop();
        }

        //transfer token to owner
        _transfer(address(this), i_owner, balance);

        //contact must close when it had the withdraw;
        status=false;
      
       emit  Withdraw_info(address(this),i_owner ,balance);
    }

    /**
     * get owner
     */
    function getOwner() public view isActive returns (address) {
        return i_owner;
    }

    /**
     * get Funder by index
     */
    function getFunder(uint256 index) public view isActive returns (address) {
        require(s_users.length<=0, "there is not user to obtain");
        return s_users[index];
    }

    function getFundationByUser(address _userAddress)
        public
        view
        isActive
        returns (uint256)
    {
        require(s_hasAddress[_userAddress], "current user is not exist");
        return s_userFundaton[_userAddress];
    }

    /**
     * get contract status
     */
    function getStatus() public view returns (bool) {
        return status;
    }

    modifier isOwner() {
        if (msg.sender != i_owner) {
            revert Storage_Not_owner();
        }
        _;
    }

    modifier isActive() {
        require(status, "current contract is close");
        _;
    }
}