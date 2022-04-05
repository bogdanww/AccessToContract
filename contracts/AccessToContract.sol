// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.0;

contract KycOracle { 
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    enum KycStatus {
        None,
        Approved,
        Rejected
    }
    struct ApprovedKyc{
        string customerIdByAddress;
        KycStatus customerStatusByAddress;
    }

    event RequestedConfirmWallet(address customer, uint256 fee);
    
    mapping(address => ApprovedKyc) public customerKyc;

    function addCustomer(address _wallet, string memory _id, KycStatus _status) public onlyOwner{
        customerKyc[_wallet].customerIdByAddress = _id;
        customerKyc[_wallet].customerStatusByAddress = _status;
    }


    function changeCustomerId(address _wallet, string memory _id) public onlyOwner {
        //require(keccak256(bytes(customerKyc[_wallet].customerIdByAddress)) == 0);
        customerKyc[_wallet].customerIdByAddress = _id;
    }

    function changeCustomerStatus(address _wallet, KycStatus _status) public onlyOwner {
        customerKyc[_wallet].customerStatusByAddress = _status;
    }

    function requestConfirmWallet() public payable {
        emit RequestedConfirmWallet(msg.sender, msg.value);
    } 
    

    modifier onlyOwner() {  
        require(msg.sender == owner);
        _;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}