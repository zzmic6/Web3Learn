// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

// Callee既没有定义receive函数，也没有定义fallback函数
contract Callee {}

// 主合约可以访问自己内部可见性为 private, internal, public 的变量和函数
contract Caller {
   address payable callee;

    // 注意： 记得在部署的时候给 Caller 合约转账一些 Wei，比如 100
    constructor() payable{
        callee = payable(address(new Callee()));
    }

    // 失败，因为Callee既没有定义receive函数，也没有定义fallback函数
    function tryTransfer() external {
        callee.transfer(1);
    }

    // 失败，因为Callee既没有定义receive函数，也没有定义fallback函数
    function trySend() external {
        bool success = callee.send(1);
        require(success, "Failed to send Ether");
    }

    // 失败，因为Callee既没有定义receive函数，也没有定义fallback函数
    function tryCall() external {
        (bool success, bytes memory data) = callee.call{value: 1}("");
        require(success, "Failed to send Ether");
    }

    // 调用 foo() 函数 
    call( abi.encodeWithSignature("foo()") );

    // 调用 foo() 函数，并转账 1 Wei 
    call{value: 1}( abi.encodeWithSignature("foo()") );

}
