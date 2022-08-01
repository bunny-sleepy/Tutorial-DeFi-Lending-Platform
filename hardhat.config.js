require("@nomiclabs/hardhat-waffle");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// Include your Private Key HERE
// const PRIVATE_KEY = ${YOUR_PRIVATE_KEY_HERE}

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
    },
    localhost: {
        url: "http://0.0.0.0:8545"
    },
    // Mumbai: {
    //   url: "https://matic-mumbai.chainstacklabs.com",
    //   accounts: [`0x${PRIVATE_KEY}`],
    // },
    // Polygon: {
    //   url: "https://polygon-rpc.com",
    //   accounts: [`0x${PRIVATE_KEY}`],
    // },
  },
  solidity: {
    version: "0.8.14",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
}