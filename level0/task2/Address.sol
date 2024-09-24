// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract Address {

    address addr = 0x690B9A9E9aa1C9dB991C7721a92d351Db4FaC990;
    address payable addr_pay = payable(addr); // **显式类型转换**

    // 地址类型有三个成员变量，分别为：

    // balance ：该地址的账户余额，单位是Wei
    // code ：该地址的合约代码，EOA 账户为空，CA 账户为非空
    // codehash ：该地址的合约代码的hash值

    function get_balance() public view returns(uint256) {
     return address(this).balance; //获取地址账户余额
    }

    function get_code() public view returns(bytes memory) {
        return address(this).code; //获取合约代码
    }

    function get_codehash() public view returns(bytes32) {
        return address(this).codehash; //获取合约代码的hash值
    }

    // 成员函数
    // 地址类型有五个成员函数：

    // transfer(uint256 amount): 向指定地址转账，不成功就抛出异常（仅address payable可以使用）
    // send(uint256 amount): 与 transfer 函数类似，但是失败不会抛出异常，而是返回布尔值 （仅address payable可以使用）
    // call(...): 调用其他合约中的函数
    // delegatecall(...): 与 call 类似，但是使用当前合约的上下文来调用其他合约中的函数，修改的也是当前合约的数据存储
    // staticcall(...): 于 call 类似，但是不会改变链上状态

    // 转账函数
    // transfer(uint256 amount)
    // send(uint256 amount) returns (bool)

    // transfer和send应该使用哪一个
    // transfer 和 send 都可以用来向另一个地址转账，那么我们应该选择用哪一个呢？答案是没有非常必要的理由，一律选 transfer 。
    //因为 transfer 是 send 的改进版，目的是在转账不成功的时候直接终止交易。而使用 send 时，你需要检查返回值看是否成功再决定做后续处理。
    //有人可能忘记检查是否成功就进行下一步处理，导致合约有被攻击的风险。
    // 但是根据最新的分析(2023年1月)，这两个函数都不安全，都不推荐继续使用。更安全的方法是使用 call 函数来转账。



    //call(bytes memory) returns (bool, bytes memory)

    // 使用 call 函数你可以与合约地址进行交互，调用其函数，或者直接向其转账。它有两个返回值，第一个是 bool ，
    // 显示函数调用是否成功。第二个是 bytes memory ，这个返回值是调用对方合约所返回的结果。与 send 和 transfer 所不同的是， 
    // call 函数可以指定Gas。



    //delegatecall(bytes memory) returns (bool, bytes memory)

    //delegatecall 是实现代理模式的手段。通过使用 delegatecall 你可以让当前合约只使用给定地址的代码，而使用当前合约的存储（如状态变量，账户余额等）
    //让当前合约 调用外部合约函数 操作当前合约数据--状态变量或者 账户余额



    // staticcall

    // staticcall 与 call 非常类似。它们的唯一区别就是 staticcall 不会改变合约的状态（包括当前合约和外部合约），
    // 一旦在调用的过程中改变了合约的状态（包括状态变量变更，账户余额改变等），那么会直接终止交易。
    // 引入 staticcall 提高了合约的安全性，因为只要你使用了 staticcall，你就可以肯定调用任何外部合约的函数不会对状态产生任何影响。
    // 而在引入 stacticall 之前，这是要通过阅读外部合约的代码来确保的。



}