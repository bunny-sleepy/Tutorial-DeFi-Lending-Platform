// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { parseUnits, concat } = require("ethers/lib/utils");
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
  // 1. Get deployer
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deployer address: ", deployer.address);

  // 2. Depoly pool
  const Pool = await hre.ethers.getContractFactory("Pool");
  let pool = await Pool.deploy();
  await pool.deployed();
  console.log("Pool Address: ", pool.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
