// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interface/ISignerVerification.sol";
import {Errors} from "./Errors.sol";
import {Constants} from "./Constants.sol";

library Helpers {
    function onlyWhitelisted(
        address _sender,
        bytes memory signature,
        address signer_,
        ISignerVerification signerVerification,
        address owner_
    ) internal pure {
        if (_sender != owner_) {
            if (
                signerVerification.isMessageVerified(
                    signer_,
                    signature,
                    _addressToString(_sender)
                )
            ) {
                revert Errors.IncorrectSignature();
            }
        }
    }

    function _validateUsernameBySymbol(
        bytes memory _username
    ) internal pure returns (bool) {
        for (uint i; i < _username.length; i++) {
            bytes1 char = _username[i];

            if (
                !(char >= 0x30 && char <= 0x39) && //9-0
                !(char >= 0x41 && char <= 0x5A) && //A-Z
                !(char >= 0x61 && char <= 0x7A) && //a-z
                !(char == 0x2E) //.
            ) return false;
        }

        return true;
    }

    function _validateUsername(string memory _username) internal pure {
        bytes memory byteUsername = bytes(_username);

        if (byteUsername.length == 0) revert Errors.IsRequireField("Username");

        if (byteUsername.length > Constants.MAX_USERNAME_LENGTH)
            revert Errors.MaxUsernameLength(Constants.MAX_USERNAME_LENGTH);

        if (!_validateUsernameBySymbol(byteUsername)) revert Errors.InvalidSymbols();
    }

    function _addressToString(
        address _addr
    ) internal pure returns (string memory) {
        bytes memory addressBytes = abi.encodePacked(_addr);

        bytes memory stringBytes = new bytes(42);

        stringBytes[0] = "0";
        stringBytes[1] = "x";

        for (uint256 i = 0; i < 20; ) {
            uint8 leftValue = uint8(addressBytes[i]) / 16;
            uint8 rightValue = uint8(addressBytes[i]) - 16 * leftValue;

            bytes1 leftChar = leftValue < 10
                ? bytes1(leftValue + 48)
                : bytes1(leftValue + 87);
            bytes1 rightChar = rightValue < 10
                ? bytes1(rightValue + 48)
                : bytes1(rightValue + 87);

            stringBytes[2 * i + 3] = rightChar;
            stringBytes[2 * i + 2] = leftChar;

            unchecked {
                i++;
            }
        }

        return string(stringBytes);
    }
}