// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

contract Constructor {
   
   uint a; // 状态变量声明，但是还没初始化

    constructor(uint aVal) {
        a = aVal; // 将 a 的值初始化为 aVal
    }

   // ExampleContract c = new ExampleContract(2);

}