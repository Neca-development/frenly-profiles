// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import {Errors} from "./Errors.sol";
import {DataTypes} from "./DataTypes.sol";
import {Constants} from "./Constants.sol";
import {Helpers} from "./Helpers.sol";
import "./interface/IProfileTokenURI.sol";
import "./interface/ISignerVerification.sol";

// import "hardhat/console.sol";

contract Profiles is
    Initializable,
    OwnableUpgradeable,
    ERC721EnumerableUpgradeable
{
    /*------------------------------------------------------Storage-------------------------------------------------------*/
    mapping(uint256 => DataTypes.ProfileStruct) internal _profileById;
    mapping(bytes32 => uint256) internal _profileIdByUsernameHash;

    uint256 private _profileCounter;

    ISignerVerification internal _signerVerification;
    address internal _signer;

    address private _accountFactory;

    uint256 public maxTotalSupply;
    IProfileTokenURI internal _profileTokenUri;

    uint256 public profilePrice;

    modifier onlyAccountFactory(address _caller) {
        if (_caller != _accountFactory) revert Errors.OnlyAccountFactory();
        _;
    }

    function initialize(
        address signer_,
        address _signerVerificationAddress,
        address _profileURIAddress,
        uint256 _maxTotalSupply,
        uint256 _profilePrice
    ) public initializer {
        __ERC721_init("frenly profiles", "frens");
        ///@dev as there is no constructor, we need to initialise the OwnableUpgradeable explicitly
        __Ownable_init();
        _profileCounter = 1;
        _signer = signer_;
        _signerVerification = ISignerVerification(_signerVerificationAddress);
        _profileTokenUri = IProfileTokenURI(_profileURIAddress);
        maxTotalSupply = _maxTotalSupply;
        profilePrice = _profilePrice;
    }

    /*------------------------------------------------------Profile Logic-------------------------------------------------------*/
    function createProfile(
        DataTypes.CreateProfileData memory args
    ) external onlyAccountFactory(msg.sender) {
        // Helpers.onlyWhitelisted(
        //     msg.sender,
        //     args.sig,
        //     _signer,
        //     _signerVerification,
        //     owner()
        // );

        Helpers._validateUsername(args.username);

        bytes32 usernameHash = keccak256(bytes(args.username));

        if (_profileIdByUsernameHash[usernameHash] != 0)
            revert Errors.UsernameAlreadyExist();

        _profileIdByUsernameHash[usernameHash] = _profileCounter;

        _safeMint(args.to, _profileCounter);

        _profileById[_profileCounter].tokenId = _profileCounter;
        _profileById[_profileCounter].username = args.username;
        _profileById[_profileCounter].owner = args.to;
        _profileById[_profileCounter].imageURI = args.imageURI;
        _profileById[_profileCounter].frenshipStatus = DataTypes
            .FrenshipStatus
            .NEWBIE;

        ++_profileCounter;
    }

    function changeAvatar(
        string memory _newAvatar,
        uint256 _profileId
    ) external {
        if (bytes(_newAvatar).length == 0)
            revert Errors.IsRequireField("avatar");

        _profileById[_profileId].imageURI = _newAvatar;
    }

    function getTokenIdByUsername(
        string memory username_
    ) public view returns (uint256) {
        bytes32 usernameHash = keccak256(bytes(username_));

        if (_profileIdByUsernameHash[usernameHash] == 0)
            revert Errors.UsernameNotExist();

        return _profileIdByUsernameHash[usernameHash];
    }

    function getProfile(
        uint256 id
    ) public view returns (DataTypes.ProfileStruct memory) {
        return _profileById[id];
    }

    function getProfileByUsername(
        string memory username_
    ) external view returns (DataTypes.ProfileStruct memory) {
        return getProfile(getTokenIdByUsername(username_));
    }

    function getProfileByAddress(
        address _profileAddress
    ) public view returns (DataTypes.ProfileStruct memory) {
        require(balanceOf(_profileAddress) != 0, "Profile not exist");
        return getProfile(tokenOfOwnerByIndex(_profileAddress, 0));
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override {
        _profileById[firstTokenId].owner = to;
        super._afterTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function changeStatus(
        DataTypes.FrenshipStatus _frenshipStatus,
        uint256 _tokenId,
        bytes memory signature
    ) external {
        // if (
        //     _signerVerification.isMessageVerified(
        //         _signer,
        //         signature,
        //         string(
        //             abi.encodePacked(
        //                 Helpers._addressToString(msg.sender),
        //                 Strings.toString(uint8(_frenshipStatus)),
        //                 Strings.toString(_tokenId)
        //             )
        //         )
        //     )
        // ) {
        //     revert Errors.IncorrectSignature();
        // }
        _profileById[_tokenId].frenshipStatus = _frenshipStatus;
    }

    /*------------------------------------------------------Operations methods-------------------------------------------------------*/

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return
            _profileTokenUri.getProfileTokenURI(
                tokenId,
                ownerOf(tokenId),
                _profileById[tokenId].username,
                _profileById[tokenId].imageURI,
                uint8(_profileById[tokenId].frenshipStatus)
            );
    }

    function setMaxTotalSupply(uint256 _newMaxTotalSupply) external onlyOwner {
        maxTotalSupply = _newMaxTotalSupply;
    }

    function setProfilePrice(uint256 _newProfilePrice) external onlyOwner {
        profilePrice = _newProfilePrice;
    }

    function setProfileTokenURI(address _profileURIAddress) external onlyOwner {
        _profileTokenUri = IProfileTokenURI(_profileURIAddress);
    }

    function setAccountFactory(address accountFactory_) external onlyOwner {
        _accountFactory = accountFactory_;
    }
}
