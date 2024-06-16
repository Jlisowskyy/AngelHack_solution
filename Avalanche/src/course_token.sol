// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CourseContract {
    address private owner;
    uint256 private accessKey;
    string[] private videoLinks;
    uint256 private price;
    mapping(address => bool) private hasAccess;

    constructor(uint256 _seed, string[] memory _videoLinks, uint256 _price) {
        owner = msg.sender;
        accessKey = generateAccessKey(_seed);
        videoLinks = _videoLinks;
        price = _price;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    function getPrice() external view returns (uint256) {
        return price;
    }

    function buyAccess() external payable {
        require(msg.value >= price, "Insufficient payment.");
        hasAccess[msg.sender] = true;
        payable(owner).transfer(msg.value);
    }

    function getAccessKey() external returns (uint256) {
        require(hasAccess[msg.sender], "You do not have access.");
        delete hasAccess[msg.sender];
        return accessKey;
    }

    function getVideoLinks(uint256 _accessKey) external view returns (string[] memory) {
        require(_accessKey == accessKey, "Invalid access key.");
        return videoLinks;
    }

    function getVideLinksOwner() external view onlyOwner returns (string[] memory)
    {
        return videoLinks;
    }

    function updatePrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function addVideoLink(string memory _newVideoLink) external onlyOwner {
        videoLinks.push(_newVideoLink);
    }

    function removeVideoLink(uint256 index) external onlyOwner {
        require(index < videoLinks.length, "Index out of bounds.");
        for (uint256 i = index; i < videoLinks.length - 1; i++) {
            videoLinks[i] = videoLinks[i + 1];
        }
        videoLinks.pop();
    }

    function generateAccessKey(uint256 seed) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, seed)));
    }
}
