// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import "./FrenlyAccount.sol";
import "./interfaces/IFrenlyProfiles.sol";
import {DataTypes} from "../DataTypes.sol";

/**
 * A sample factory contract for SimpleAccount
 * A UserOperations "initCode" holds the address of the factory, and a method call (to createAccount, in this sample factory).
 * The factory's createAccount returns the target account address even if it is already installed.
 * This way, the entryPoint.getSenderAddress() can be called either before or after the account is created.
 */
contract FrenlyAccountFactory {
    FrenlyAccount public immutable accountImplementation;
    IFrenlyProfiles public immutable profileImplementation;

    constructor(
        IEntryPoint _entryPoint,
        address _profileImplementationAddress
    ) {
        accountImplementation = new FrenlyAccount(_entryPoint);
        profileImplementation = IFrenlyProfiles(_profileImplementationAddress);
    }

    /**
     * create an account, and return its address.
     * returns the address even if the account is already deployed.
     * Note that during UserOperation execution, this method is called only if the account is not deployed.
     * This method returns an existing account address so that entryPoint.getSenderAddress() would work even after account creation
     */
    function createAccount(
        address owner,
        uint256 salt,
        string memory username,
        string memory imageUrl
    ) public returns (FrenlyAccount ret) {
        address addr = getAddress(owner, salt);
        uint codeSize = addr.code.length;
        if (codeSize > 0) {
            return FrenlyAccount(payable(addr));
        }

        DataTypes.CreateProfileData memory profileInfo = DataTypes
            .CreateProfileData(addr, username, imageUrl);

        profileImplementation.createProfile(profileInfo);

        ret = FrenlyAccount(
            payable(
                new ERC1967Proxy{salt: bytes32(salt)}(
                    address(accountImplementation),
                    abi.encodeCall(FrenlyAccount.initialize, (owner))
                )
            )
        );
    }

    /**
     * calculate the counterfactual address of this account as it would be returned by createAccount()
     */
    function getAddress(
        address owner,
        uint256 salt
    ) public view returns (address) {
        return
            Create2.computeAddress(
                bytes32(salt),
                keccak256(
                    abi.encodePacked(
                        type(ERC1967Proxy).creationCode,
                        abi.encode(
                            address(accountImplementation),
                            abi.encodeCall(FrenlyAccount.initialize, (owner))
                        )
                    )
                )
            );
    }
}
