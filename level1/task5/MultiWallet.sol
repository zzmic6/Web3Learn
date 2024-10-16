// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

error Invalid_Transaction(address sponsor);

error Not_Allow_Execute(address sponsor);

contract MultiWallet {
    address[] private allOwner;

    uint16 private immutable sign_count;

    //transaction status;
    enum TxStatus {
        START,
        APPROVED,
        FINISH
    }

    struct ApproveInfo {
        address owner;
        bool isExecute;
        uint256 approveCount;
        address[] approveAddress;
        mapping(address => bool) isApprove;
        TxStatus status;
    }

    mapping(address => uint256) tx_Sponsor;

    mapping(address => ApproveInfo) tx_approve_info;

    event Already_Approve(address sponsor, address approve);

    event Execute_Finish(address sponsor);

    constructor(address[] memory _addressArr, uint16 _sign_count) {
        allOwner = _addressArr;
        sign_count = _sign_count;
    }

    function submit() external payable {
        uint256 value = msg.value;
        address sponsor = msg.sender;

        if (tx_Sponsor[sponsor] > 0) {
            revert Invalid_Transaction(sponsor);
        }

        tx_Sponsor[sponsor] = value;
    }

    function approve(address sponsor) external {
        address _approve = msg.sender;
        ApproveInfo storage newApproveInfo = tx_approve_info[sponsor];

        if (newApproveInfo.isApprove[_approve]) {
            emit Already_Approve(sponsor, _approve);
            return;
        }
        newApproveInfo.owner = sponsor;
        newApproveInfo.approveCount += 1;

        if (newApproveInfo.approveCount >= sign_count) {
            newApproveInfo.isExecute = true;
        }

        newApproveInfo.approveAddress.push(_approve);
        newApproveInfo.isApprove[_approve] = true;
        newApproveInfo.status = TxStatus.APPROVED;

        emit Already_Approve(sponsor, _approve);
    }

    function execute(address sponsor) external {
        require(!tx_approve_info[sponsor].isExecute, "don't allow to execute");
        require(
            tx_approve_info[sponsor].status != TxStatus.FINISH,
            "it has finished"
        );

        (bool success, ) = payable(sponsor).call{value: tx_Sponsor[sponsor]}(
            ""
        );

        if (success) {
            emit Execute_Finish(sponsor);
            tx_approve_info[sponsor].status = TxStatus.FINISH;
        }
    }

    function cancel(address sponsor) external {
        if (tx_Sponsor[sponsor] > 0) {
            revert Invalid_Transaction(sponsor);
        }
        tx_Sponsor[sponsor] = 0;

        ApproveInfo storage approveInnfo = tx_approve_info[sponsor];

        approveInnfo.owner = address(0);
        approveInnfo.isExecute = false;
        approveInnfo.approveCount = 0;
        approveInnfo.status = TxStatus.START;

        address[] storage _approveAddress = approveInnfo.approveAddress;

        while(_approveAddress.length > 0){
            approveInnfo.isApprove[_approveAddress[0]]=false;
            _approveAddress[0]=_approveAddress[_approveAddress.length-1];
            _approveAddress.pop();
        }
        
    }

    function getLowSignCount() external view returns (uint16) {
        return sign_count;
    }

    function getSponsorStatus(address sponsor) external view returns(TxStatus){
        return tx_approve_info[sponsor].status;
    }

     function getSponsorapproveCount(address sponsor) external view returns(uint256){
        return tx_approve_info[sponsor].approveCount;
    }

     function getSponsorapprove(address sponsor) external view returns(address[] memory){
        return tx_approve_info[sponsor].approveAddress;
    }
}