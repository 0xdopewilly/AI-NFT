require("dotenv").config();
require("hardhat-contract-sizer");
require("@nomiclabs/hardhat-etherscan");
require("@nomicfoundation/hardhat-chai-matchers");
require("hardhat-gas-reporter");
require("solidity-coverage");

const BASESCAN_API_KEY = process.env.BASESCAN_API_KEY;
const BASE_SEPOLIA_RPC_URL = process.env.BASE_SEPOLIA_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    localhost: {
      chainId: 31337,
    },
    ganache: {
      chainId: 1337,
      url: "http://127.0.0.1:7545",
      accounts: [PRIVATE_KEY],
    },
    basesepolia: {
      url: BASE_SEPOLIA_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 84531, // Chain ID for Base Sepolia
    },
  },
  paths: {
    artifacts: "./artifacts",
  },
  gasReporter: {
    enabled: true,
  },
  etherscan: {
    apiKey: BASESCAN_API_KEY,
  },
  mocha: {
    timeout: 60000,
  },
};