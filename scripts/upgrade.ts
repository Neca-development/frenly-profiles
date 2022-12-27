// const { ethers, upgrades } = require("hardhat");

// async function main() {


//   const Profiles = await ethers.getContractFactory("Profiles", 
//   // {
//   //   libraries: {
//   //     "Constants": constants.address,
//   //     "DataTypes": dataTypes.address,
//   //     "Errors": errors.address,
//   //     "Helpers": helpers.address,
//   //     "ProfileTokenURI": profileTokenURI.address
//   //   }
//   // }
  
//   );


//   const profiles = await upgrades.upgradeProxy('0x187854376d56603dDEF2aA31480f722E64F7b939', Profiles);
//   await profiles.deployed();
//   console.log("⏏️ Profiles upgraded", profiles);
// }

// // We recommend this pattern to be able to use async/await everywhere
// // and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
