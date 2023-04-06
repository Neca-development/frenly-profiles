const {ethers, upgrades} = require("hardhat")

async function main() {
  // const SignerVerification = await ethers.getContractFactory('SignerVerification')
  // const signerVer = await SignerVerification.deploy()
  // await signerVer.deployed()

  // console.log("✅ signerVer:address", signerVer.address)

  

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

  // const Helpers = await ethers.getContractFactory("Helpers")
  // const helpers = await Helpers.deploy()
  // await helpers.deployed() 
  // console.log("✅ helpers:address", helpers.address)

  const ProfileTokenURI = await ethers.getContractFactory("ProfileTokenURI")
  const profileTokenURI = await ProfileTokenURI.deploy()
  await profileTokenURI.deployed() 
  console.log("✅ profileTokenURI:address", profileTokenURI.address)

  // const Storage = await ethers.getContractFactory("Storage")
  // const storage = await Storage.deploy()
  // await storage.deployed() 
  // console.log("✅ storage:address", storage.address)


  // const Profiles = await ethers.getContractFactory("Profiles", 
  // {
    
    // libraries: {
    //   "Constants": constants.address,
    //   "DataTypes": dataTypes.address,
    //   "Errors": errors.address,
    //   "Helpers": helpers.address,
    //   // "ProfileTokenURI": profileTokenURI.address
    // }
  // }
  // );
  // const profilesBeacon = await upgrades.deployBeacon(Profiles, {unsafeAllow: ['external-library-linking']});

  // await profilesBeacon.deployed() 

  // const profiles = await upgrades.deployBeaconProxy(profilesBeacon, Profiles, ['0xe7b5B35181eeB87A6f2EE68ef923c4016Cd552fa', signerVer.address, profileTokenURI.address, ethers.BigNumber.from('10000'), 0])


  // const profiles = await upgrades.deployProxy(Profiles, ['0xe7b5B35181eeB87A6f2EE68ef923c4016Cd552fa', signerVer.address, profileTokenURI.address, ethers.BigNumber.from(10000), 0]);
  // await profiles.deployed();
  // console.log("✅ Profiles deployed to:", profiles.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
