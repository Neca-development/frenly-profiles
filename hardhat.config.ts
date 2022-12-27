import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('@openzeppelin/hardhat-upgrades');

const config = {
  solidity: "0.8.17",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    }
  },
  networks: {
    mumbai: {
      url: 'https://polygon-mumbai.g.alchemy.com/v2/GHk7QUctHo69C1VGlveQ6cSu1-664KaS',
      accounts: ['2923eaece8b287525743a66e5159bd8c130289bddb5b2ff47b3a803bb99039d2'],
    },
    polygon: {
      url: 'https://polygon-mainnet.g.alchemy.com/v2/Ry95d_MJm_Civdt-BUYFSO2EdFX1bh8A',
      accounts: ['2923eaece8b287525743a66e5159bd8c130289bddb5b2ff47b3a803bb99039d2'],
    },
    goerli: {
      url: 'https://eth-goerli.g.alchemy.com/v2/gd7-Ve7TqXgn08lk3iqt48SkC4LY7wj7',
      accounts: ['39fd3c82d3ef35cd6bd30e99d74a2e7edb3680cf2244dfe899a0bca2a2228ee8'],
    },
   
  },
  etherscan: {
    apiKey: "IKSV8AY4U7TFMRNDJZUBHCMPYJ8KT9WNUI",
  },
  gasReporter: {
    enabled: true,
    coinmarketcap: 'af8ddfb6-5886-41fe-80b5-19259a3a03be',
    currency: 'matic',
    token: 'matic',
    gasPriceApi: 'https://api.polygonscan.com/api?module=proxy&action=eth_gasPrice'
    // gasPrice: 23,
  },
};

export default config;
