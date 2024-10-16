// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ETHWallet {
    

    function fund() external payable {
        
    }

    function withdraw() external  {
        address _sender=msg.sender;
        payable(_sender).transfer(address(this).balance);
    }

    function withdrawV2() external  {
        address _sender=msg.sender;
       bool success= payable(_sender).send(address(this).balance);
       if (!success){
            revert();
       }
    }

    function withdrawV3() external  {
        address _sender=msg.sender;
       (bool success,)= payable(_sender).call{value:address(this).balance}("");
       if (!success){
            revert();
       }
    }
}