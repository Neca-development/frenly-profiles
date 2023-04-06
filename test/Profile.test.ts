import { base64 } from 'ethers/lib/utils';
import { Profiles } from './../typechain-types/contracts/Profiles';
import { Profiles__factory } from './../typechain-types/factories/contracts/Profiles__factory';
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, upgrades } from "hardhat";
import base64url from "base64url";
import { base64ToJSON, base64ToString } from './utils';

async function deployFixture() {

  // Contracts are deployed using the first signer/account by default
  const [owner, otherAccount] = await ethers.getSigners();

  const SignerVerification = await ethers.getContractFactory('SignerVerification')
  const signerVer = await SignerVerification.deploy()
  await signerVer.deployed()
  console.log("✅ signerVer:address", signerVer.address)

  // const Constants = await ethers.getContractFactory("Constants")
  // const constants = await Constants.deploy()
  // await constants.deployed()
  // console.log("✅ constants:address", constants.address)
  
  // const DataTypes = await ethers.getContractFactory("DataTypes")
  // const dataTypes = await DataTypes.deploy()
  // await dataTypes.deployed() 
  // console.log("✅ dataTypes:address", dataTypes.address)


  // const Errors = await ethers.getContractFactory("Errors")
  // const errors = await Errors.deploy()
  // await errors.deployed() 
  // console.log("✅ errors:address", errors.address)

  // const Helpers = await ethers.getContractFactory("Helpers", 
  // // {
  //   // libraries:{
  //   //   "Errors": errors.address,
  //   //   "Constants": constants.address,
  //   // }
  // // }
  // )
  // const helpers = await Helpers.deploy()
  // await helpers.deployed() 
  // console.log("✅ helpers:address", helpers.address)

  const ProfileTokenURI = await ethers.getContractFactory("ProfileTokenURI")
  const profileTokenURI = await ProfileTokenURI.deploy()
  await profileTokenURI.deployed() 

  console.log("✅ profileTokenURI:address", profileTokenURI.address)
  
  const Profiles = await ethers.getContractFactory("Profiles", 
  // {
    
    // libraries: {
    //   "Constants": constants.address,
    //   "DataTypes": dataTypes.address,
    //   "Errors": errors.address,
    //   "Helpers": helpers.address,
    //   // "ProfileTokenURI": profileTokenURI.address
    // }
  // }
  );
  const profilesBeacon = await upgrades.deployBeacon(Profiles, {unsafeAllow: ['external-library-linking']});

  await profilesBeacon.deployed() 

  const profiles = await upgrades.deployBeaconProxy(profilesBeacon, Profiles, [owner.address, signerVer.address, profileTokenURI.address, ethers.BigNumber.from('10000'), 0])

  return {  owner, otherAccount, profiles };
}

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  beforeEach(async ()=>{

  })

  describe("Deployment", function () {
    it("Should set the right unlockTime", async function () {
      const {  owner, profiles } = await loadFixture(deployFixture);

      const username = 'sasha😊'

      await profiles.createProfile({imageURI: 'https://avatarko.ru/img/kartinka/1/Crazy_Frog.jpg', sig: '0x39d92deb64de7e86e4af5eec547ddd71cab383e62df3b89f4a627adcdd153a54427c5239052eba589d38083546e60cd4250e1e8eb61915f4dd73dc024f302e711c', to: owner.address, username})

      const createdProfile = await profiles.getProfileByUsername(username)
      const createdProfile2 = await profiles.getProfileByAddress(owner.address)
      console.log(createdProfile, createdProfile2);
      
    });
    it("Should set the right unlockTime", async function () {
      const {  owner, profiles } = await loadFixture(deployFixture);

      const username = `Sasha ${'😂'}`

      await profiles.createProfile(
        {imageURI: 'https://avatarko.ru/img/kartinka/1/Crazy_Frog.jpg', sig: '0x39d92deb64de7e86e4af5eec547ddd71cab383e62df3b89f4a627adcdd153a54427c5239052eba589d38083546e60cd4250e1e8eb61915f4dd73dc024f302e711c', to: owner.address, username}
        )

      const data = await profiles.tokenURI(1)

      const parsedData = base64ToJSON(data)

      // console.log(parsedData);
      

      console.log(base64ToString(parsedData.image));
      

    });

    
  })
})
