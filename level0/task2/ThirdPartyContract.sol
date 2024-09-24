// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;
import "./MainContract.sol";

contract ThirdPartyContract {
      function funcThirdParty(address mainContractAddress) private {
            MainContract(mainContractAddress).funcExternal(); // 第三方合约可以访问主合约中可见性为external，public的函数
            MainContract(mainContractAddress).funcPublic(); // 第三方合约可以访问主合约中可见性为external，public的函数
      }
}
