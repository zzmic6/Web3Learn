// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract Integer {
    function overflow() public pure {
        uint8 a = 255;
        a = a+1; //整型溢出，整个transaction revertconsole.log("a=%s", a);
    }
}