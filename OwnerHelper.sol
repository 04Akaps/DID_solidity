// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

contract OwnerHelper {
    address private owner;

    event OwnerTransferPropose(address indexed _From, address indexed _to);

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function showOwner() public view returns (address){
        return owner;
    }

    function transferOwnership(address _to) onlyOwner public {
        require(_to != owner);
        require(_to != address(0x0));
        owner = _to;
        emit OwnerTransferPropose(owner, _to);
    }
}