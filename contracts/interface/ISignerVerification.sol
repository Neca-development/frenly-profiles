//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import '@openzeppelin/contracts/utils/Strings.sol';

interface ISignerVerification {
	/**
	 * @dev Returns bool value if message is verified by right signer.
	 */
	function isMessageVerified(address signer, bytes calldata signature,string calldata concatenatedParams) external pure returns (bool);
    
    /**
	 * @dev Returns address of signer;
	 */
    function getSigner(bytes calldata signature, string calldata concatenatedParams) external pure returns (address);

}
