// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

import "./IssuerHelper.sol";

contract CredentialBox is IssuerHelper{
    // 기본적으로 발급자는 컨트랙트 실행자 지정
    address private issuerAddress;
    // 발급 횟수를 말합니다.
    uint256 private idCount;
    // 백신의 종류
    mapping(uint8 => string) private alumniEnum;
    string[] internal vaccineList;

    // 인증서를 의미
    struct Credential{
        uint256 id;
        address issuer;
        string alumniType;
        string value;
    }

    // 사용자에 따른 인증서
    mapping(address => Credential) private credentials;

    constructor() {
        issuerAddress = msg.sender;
        idCount = 1;
        alumniEnum[0] = "Pfizer";
        alumniEnum[1] = "Moderna";
        alumniEnum[2] = "AstraZeneca";
        // 얀센은 함수를 통해 추가 하기로   
        vaccineList.push("Pfizer");
        vaccineList.push("Moderna");
        vaccineList.push("AstraZeneca");
    }
    
    // 인증서 발급 함수
    function claimCredential(address _alumniAddress, uint8 _alumniType, string calldata _value) public returns(bool){
        require(issuerAddress == msg.sender, "Not Issuer");
				Credential storage credential = credentials[_alumniAddress];
        require(credential.id == 0);
        require(_alumniType >= 0 && _alumniType < vaccineList.length);
        credential.id = idCount;
        credential.issuer = msg.sender;
        credential.alumniType = alumniEnum[_alumniType];
        credential.value = _value;
        
        idCount += 1;
        return true;
    }

    function showVaccineList() view public returns(string[] memory) {
        return vaccineList; 
    }

    function addVaccine(string memory _new) public onlyOwner returns(bool) {
        vaccineList.push(_new);
        uint8 length = uint8(vaccineList.length -1);
        alumniEnum[length] = _new;
        return true;
    }

    // 인증서 확인 함수
    function getCredential(address _alumniAddress) public view returns (Credential memory){
        return credentials[_alumniAddress];
    }

}