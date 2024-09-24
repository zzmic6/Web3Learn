// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;
import "./MainContract.sol";

contract ChildContract is MainContract {
    function funcChild() private {
        funcInternal(); // 子合约可以访问主合约中可见性为internal，public的函数
        funcPublic(); // 子合约可以访问主合约中可见性为internal，public的函数
    }
}
