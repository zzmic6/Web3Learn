// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

// 主合约可以访问自己内部可见性为 private, internal, public 的变量和函数
contract MainContract {
    uint varPrivate;
    uint varInternal;
    uint varPublic;

    function funcPrivate() private {}
    function funcInternal() internal {}
    function funcExternal() external {}
    function funcPublic() public {}
}
