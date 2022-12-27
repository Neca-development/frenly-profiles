//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
interface IProfileTokenURI {
    function getProfileTokenURI(uint256 id,address owner,string memory username,string memory imageURI, string memory description, string memory role) external pure returns (string memory);
}