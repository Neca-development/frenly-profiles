// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

contract BalanceTest {
    address[2] public balances;

    function addBalance(address send) public {
        balances[0] = send;
        balances[1] = msg.sender;
    }

    function getBalance() public view returns (address[2] memory) {
        return balances;
    }
}
