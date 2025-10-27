const hre = require("hardhat");

async function main() {
  const DappMint = await hre.ethers.getContractFactory("DappMint");
  const dappMint = await DappMint.deploy();

  await dappMint.deployed();

  console.log("✅ DappMint deployed to:", dappMint.address);
}

// Handle async errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
