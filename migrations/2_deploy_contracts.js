const User = artifacts.require("User");
const WorkHiveToken = artifacts.require("WorkHiveToken");
const Payment = artifacts.require("Payment");
const ResumeReviews = artifacts.require("ResumeReviews");

module.exports = async function(deployer, network, accounts) {
    // Deploy User contract
    await deployer.deploy(User);
    const userInstance = await User.deployed();

    // Deploy WorkHiveToken with the address of ERC20 and User contract
    await deployer.deploy(WorkHiveToken, userInstance.address);
    const workHiveTokenInstance = await WorkHiveToken.deployed();

    // Deploy Payment contract with the address of User and WorkHiveToken contracts
    await deployer.deploy(Payment, userInstance.address, workHiveTokenInstance.address);
    const paymentInstance = await Payment.deployed();

    // Deploy ResumeReviews contract with the address of User contract
    await deployer.deploy(ResumeReviews, userInstance.address);
    const resumeReviewsInstance = await ResumeReviews.deployed();

    console.log("Contracts deployed successfully:");
    console.log("Owner:", accounts[0]);
    console.log("User Address:", userInstance.address);
    console.log("WorkHiveToken Address:", workHiveTokenInstance.address);
    console.log("Payment Address:", paymentInstance.address);
    console.log("ResumeReviews Address:", resumeReviewsInstance.address);
};
