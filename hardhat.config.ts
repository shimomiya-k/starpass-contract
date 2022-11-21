import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const { PRIVATE_KEY, ETHERSCAN_API, POLYGON_URL } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    mumbai: {
      url: POLYGON_URL,
      accounts: [PRIVATE_KEY!],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API,
  },
};

export default config;
