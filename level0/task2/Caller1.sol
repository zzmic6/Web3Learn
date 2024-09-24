
// SPDX-License-Identifier: GPL-3.0


import "./Callee.sol"; 

pragma solidity ^0.8.17;
//0xA74098e3398EC2f78CdA221D7ec8680e158a0cbF

//0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d
contract Caller {
    address payable callee;

    // 注意： 记得在部署的时候给 Caller 合约转账一些 Wei，比如 100
    // 因为在调用下面的函数时需要用到一些 Wei
    constructor() payable{
        callee = payable(address(new Callee()));
    }

    // 触发 receive 函数
    function transferReceive() external {
        callee.transfer(1 ether);
    }

    // 触发 receive 函数
    function sendReceive() external {
        bool success = callee.send(1);
        require(success, "Failed to send Ether");
    }

    // 触发 receive 函数
    function callReceive() external {
        (bool success, bytes memory data) = callee.call{value: 1}("");
        require(success, "Failed to send Ether");
    }

    // 触发 foo 函数
    function callFoo() external {
        (bool success, bytes memory data) = callee.call{value: 1}(
            abi.encodeWithSignature("foo()")
        );
        require(success, "Failed to send Ether");
    }

    // 触发 fallback 函数，因为 funcNotExist() 在 Callee 没有定义
    function callFallback() external {
        (bool success, bytes memory data) = callee.call{value: 1}(
            abi.encodeWithSignature("funcNotExist()")
        );
        require(success, "Failed to send Ether");
    }

        function getBalance() public view  returns (uint){
        return address(this).balance;
    }

    function trabsfer11() payable external {
        address payable  ac = payable (0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB);
        ac.transfer(10 ether);
    }
}
