// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./course_token.sol";

contract UserContract {
    string public username;
    string public imageUrl;

    mapping(address => uint256) private contractsMap;
    uint256 private contractCount;
    address private owner;

    constructor(string memory _username, string memory _imageUrl) {
        username = _username;
        imageUrl = _imageUrl;
        contractCount = 0;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform the action.");
        _;
    }

    function buyAccessKeyFromCourseContract(address _courseContractAddress) public payable onlyOwner {
        require(contractsMap[_courseContractAddress] == 0, "User already bought the rights");

        CourseContract courseContract = CourseContract(_courseContractAddress);
        uint256 price = courseContract.getPrice();
        require(msg.value >= price, "Insufficient payment.");

        courseContract.buyAccess{value: msg.value}();

        uint256 accessKey = courseContract.getAccessKey();

        contractsMap[_courseContractAddress] = accessKey;
        contractCount++;
    }

    function getContractCount() public view onlyOwner returns (uint256) {
        return contractCount;
    }

    function getVideoLinksFromCourseContract(address _contractAddress)
        public
        view
        onlyOwner
        returns (string[] memory)
    {
        require(contractsMap[_contractAddress] != 0, "User does not posses access to the course!");

        CourseContract courseContract = CourseContract(_contractAddress);
        return courseContract.getVideoLinks(contractsMap[_contractAddress]);
    }
}
