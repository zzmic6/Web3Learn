// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

contract Immutable {

    uint immutable n = 5;

    // uint immutable n;

    // constructor () {
    //     n = 5;
    // }

    // function f() public {
    // n = 5; // 不合法， 不能在函数初始化 immutable 变量 
    // }

    // function f() public {
    //     n = 5; // 不合法，immutable 变量不能更改
    // }
}