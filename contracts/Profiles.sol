// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./interface/IProfileTokenURI.sol";
import "./interface/ISignerVerification.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Profiles is 
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    ERC721Upgradeable {

/*------------------------------------------------------Data Types----------------------------------------------------*/

    struct ProfileStruct {
        uint256 tokenId;
        string username;
        address owner;
        string imageURI; 
        string description;
        string role;
    }

    struct CreateProfileData {
        address to;
        string username;
        string imageURI;
        bytes sig;
        string description;
        string role;
    }
/*------------------------------------------------------Storage-------------------------------------------------------*/
    mapping(uint256 => ProfileStruct) internal _profileById;
    mapping(bytes32 => uint256) internal _profileIdByUsernameHash;

    uint256 internal _profileCounter;

    ISignerVerification internal _signerVerification;
    address internal _signer;

    IProfileTokenURI internal _profileTokenUri;
/*------------------------------------------------------Errors-------------------------------------------------------*/
    error UsernameIsRequireField();
    error UsernameAlreadyExist();
    error UsernameNotExist();
    error MaxUsernameLength(uint8 _maxLength);
    error IncorrectSignature();

/*------------------------------------------------------Helpers-------------------------------------------------------*/
function onlyWhitelisted(address _sender, bytes memory signature, address signer_, ISignerVerification signerVerification, address owner_ ) internal pure {
        if(_sender != owner_) {
            if(signerVerification.isMessageVerified(signer_, signature, _addressToString(_sender))){
            revert IncorrectSignature();
        }
        }  
    }

    function _addressToString(address _addr) internal pure returns (string memory) {
		bytes memory addressBytes = abi.encodePacked(_addr);

        bytes memory stringBytes = new bytes(42);

        stringBytes[0] = '0';
        stringBytes[1] = 'x';

        for (uint256 i = 0; i < 20;) {
            uint8 leftValue = uint8(addressBytes[i]) / 16;
            uint8 rightValue = uint8(addressBytes[i]) - 16 * leftValue;

            bytes1 leftChar = leftValue < 10 ? bytes1(leftValue + 48) : bytes1(leftValue + 87);
            bytes1 rightChar = rightValue < 10 ? bytes1(rightValue + 48) : bytes1(rightValue + 87);

            stringBytes[2 * i + 3] = rightChar;
            stringBytes[2 * i + 2] = leftChar;

        unchecked {i++;}}

        return string(stringBytes);
	}


/*------------------------------------------------------Constants-------------------------------------------------------*/
    uint8 constant MAX_USERNAME_LENGTH = 30;





    function initialize(address signer_, address _signerVerificationAddress, address _profileURIAddress) initializer public {
        __ERC721_init("FrenlyProfile", "FNS");
         ///@dev as there is no constructor, we need to initialise the OwnableUpgradeable explicitly
        __Ownable_init();
        _profileCounter = 1;
        _signer = signer_;
        _signerVerification = ISignerVerification(_signerVerificationAddress);
        _profileTokenUri = IProfileTokenURI(_profileURIAddress);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
/*------------------------------------------------------Profile Logic-------------------------------------------------------*/
    function createProfile(CreateProfileData calldata args) external {

        onlyWhitelisted(msg.sender, args.sig, _signer, _signerVerification, owner());

        _validateUsername(args.username);

        bytes32 usernameHash = keccak256(bytes(args.username));        

        if(_profileIdByUsernameHash[usernameHash] != 0) revert UsernameAlreadyExist();

        _profileIdByUsernameHash[usernameHash] = _profileCounter;

        _safeMint(args.to, _profileCounter);

        _profileById[_profileCounter].tokenId = _profileCounter;
        _profileById[_profileCounter].username = args.username;
        _profileById[_profileCounter].owner = args.to;
        _profileById[_profileCounter].imageURI = args.imageURI;
        _profileById[_profileCounter].description = args.description;
        _profileById[_profileCounter].role = args.role;

        ++_profileCounter;

    }

    function getTokenIdByUsername(string memory username_) public view returns(uint256) {
        bytes32 usernameHash = keccak256(bytes(username_)); 

        if(_profileIdByUsernameHash[usernameHash] == 0) revert UsernameNotExist();

        return _profileIdByUsernameHash[usernameHash];
    }

    function getProfile(uint256 id) public view returns (ProfileStruct memory) {
        return _profileById[id];
    }

    function getProfileByUsername(string memory username_) public view returns (ProfileStruct memory) {
        return _profileById[getTokenIdByUsername(username_)];
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return _profileTokenUri.getProfileTokenURI(
                tokenId,
                ownerOf(tokenId),
                _profileById[tokenId].username,
                _profileById[tokenId].imageURI,
                _profileById[tokenId].description,
                _profileById[tokenId].role
            );
    }

    function setProfileTokenURI(address _profileURIAddress)public onlyOwner{
        _profileTokenUri = IProfileTokenURI(_profileURIAddress);
    }

    function _validateUsername(string memory _username) private pure{
        bytes memory byteUsername = bytes(_username);

        if(byteUsername.length == 0){ 
            revert UsernameIsRequireField();
        }

        if(byteUsername.length > MAX_USERNAME_LENGTH){ 
            revert MaxUsernameLength(MAX_USERNAME_LENGTH);
        }

    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override{
        _profileById[firstTokenId].owner = to;
        super._afterTokenTransfer(from, to, firstTokenId,batchSize);
    }
}
