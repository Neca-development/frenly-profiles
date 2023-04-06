// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

library Errors {
    error IsRequireField(string field);
    error UsernameAlreadyExist();
    error UsernameNotExist();
    error MaxUsernameLength(uint8 _maxLength);
    error IncorrectSignature();
    error InvalidSymbols();
}