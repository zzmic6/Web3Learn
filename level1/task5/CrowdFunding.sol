// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

error CorwdFunding_Fail(address corwdFundingAddrss);
error Funder_Close(address _beneficiary);

contract CrowdFunding {
    //funders
    struct FunderInfo {
        address beneficiary;
        mapping(address => uint256) funderMapping;
        uint256 totalAmount;
        address[] funders;
        mapping(address => bool) hasFunderAddress;
        bool is_need_CrowdFunding;
    }

    //current beneficiary
    address[] private beneficiarys;

    mapping(address => bool) hasBeneficiary;

    mapping(address => FunderInfo) private beneficiaryMapping;

    function startCorwdFunding(address _beneficiary) external payable {
        uint256 value = msg.value;

        address funderAddress = msg.sender;

        (bool success, ) = payable(_beneficiary).call{value: value}("");

        if (!hasBeneficiary[_beneficiary]) {
            hasBeneficiary[_beneficiary] = true;
            FunderInfo storage newFunderInfo = beneficiaryMapping[_beneficiary];
            newFunderInfo.beneficiary = _beneficiary;
            newFunderInfo.is_need_CrowdFunding = true;
            newFunderInfo.totalAmount += msg.value;

            newFunderInfo.hasFunderAddress[funderAddress] = true;
            newFunderInfo.funders.push(funderAddress);
            newFunderInfo.funderMapping[funderAddress] += msg.value;

            beneficiarys.push(_beneficiary);
        } else if (!beneficiaryMapping[_beneficiary].is_need_CrowdFunding) {
            revert Funder_Close(_beneficiary);
        } else {
            if (
                !beneficiaryMapping[_beneficiary].hasFunderAddress[
                    funderAddress
                ]
            ) {
                beneficiaryMapping[_beneficiary].hasFunderAddress[
                    funderAddress
                ] = true;
                beneficiaryMapping[_beneficiary].funders.push(funderAddress);
            }
            beneficiaryMapping[_beneficiary].funderMapping[funderAddress] += msg
                .value;
            beneficiaryMapping[_beneficiary].totalAmount += msg.value;
        }

        if (!success) {
            revert CorwdFunding_Fail(_beneficiary);
        }
    }



    function getBeneficiary(uint256 _index) external view returns ( address) {
        return beneficiarys[_index];
    }

    function getBeneficiaryTotalAmount(address _beneficiaryAdderess) public view  returns (uint256) {
        return beneficiaryMapping[_beneficiaryAdderess].totalAmount;
    }

     function getBeneficiaryFunders(address _beneficiaryAdderess) public view  returns (address[] memory) {
        return beneficiaryMapping[_beneficiaryAdderess].funders;
    }

    function getBeneficiaryStatus(address _beneficiaryAdderess) public view  returns (bool) {
        return beneficiaryMapping[_beneficiaryAdderess].is_need_CrowdFunding;
    }

    function getFunderAmount(address _beneficiaryAdderess,address funderAddress) public view  returns (uint256) {
        return beneficiaryMapping[_beneficiaryAdderess].funderMapping[funderAddress];
    }
}