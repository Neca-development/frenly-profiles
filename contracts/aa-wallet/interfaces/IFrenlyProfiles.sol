// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

import {DataTypes} from "../../DataTypes.sol";

interface IFrenlyProfiles {
    function createProfile(DataTypes.CreateProfileData memory args) external;
}
