// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

library DataTypes {
    enum FrenshipStatus {
        NEWBIE,
        FREN,
        BEST_FREN,
        BEST_FREN_FOREVER
    }

    struct ProfileStruct {
        uint256 tokenId;
        string username;
        address owner;
        string imageURI;
        FrenshipStatus frenshipStatus;
    }

    struct CreateProfileData {
        address to;
        string username;
        string imageURI;
        // bytes sig;
    }
}