const truffleAssert = require("truffle-assertions");

const Payment = artifacts.require("Payment");
const User = artifacts.require("User");
const WorkHiveToken = artifacts.require("WorkHiveToken");

contract("Payment", (accounts) => {
  let paymentInstance, userInstance, tokenInstance, erc20Instance;
  let clientId, freelancerId;

  const owner = accounts[0];
  const client = accounts[1];
  const freelancer = accounts[2];
  const jobId = 1;
  const amount = 1;

  before(async () => {
    // Deploy the contracts
    userInstance = await User.deployed();
    tokenInstance = await WorkHiveToken.deployed();
    paymentInstance = await Payment.deployed();
  });

  it("should register a new freelancer user", async () => {
    const username = "freelancer1";
    const name = "John Doe";
    const email = "freelancer1@example.com";

    const result = await userInstance.register(
      0, // UserType.Freelancer
      username,
      name,
      email,
      { from: freelancer }
    );

    freelancerId = result.logs[0].args.userId.toNumber();
    assert.equal(
      result.logs[0].event,
      "NewUserRegistered",
      "NewUserRegistered event not emitted"
    );

    const userDetails = await userInstance.getUserDetails(freelancerId);
    assert.equal(userDetails.username, username, "Usernames do not match");
    assert.equal(userDetails.name, name, "Names do not match");
    assert.equal(userDetails.email, email, "Emails do not match");
  });

  it("should register a new client user", async () => {
    const username = "client1";
    const name = "Jane Smith";
    const email = "client1@example.com";

    const result = await userInstance.register(
      1, // UserType.Client
      username,
      name,
      email,
      { from: client }
    );

    clientId = result.logs[0].args.userId.toNumber();
    assert.equal(
      result.logs[0].event,
      "NewUserRegistered",
      "NewUserRegistered event not emitted"
    );

    const userDetails = await userInstance.getUserDetails(clientId);
    assert.equal(userDetails.username, username, "Usernames do not match");
    assert.equal(userDetails.name, name, "Names do not match");
    assert.equal(userDetails.email, email, "Emails do not match");
  });

  it("should mint tokens for client", async () => {
    // Ensure the `owner` has authorization to mint
    await tokenInstance.addAuthorised(owner, { from: owner });

    // Mint tokens to the client
    const mint = await tokenInstance.mintToken(
      web3.utils.toWei("10", "ether"),
      client
    );

    truffleAssert.eventEmitted(mint, "MintToken");
  });

  it("should initiate a payment", async () => {
    await tokenInstance.approve(client, amount, {
      from: client,
    });

    const result = await paymentInstance.initiatePayment(
      clientId,
      freelancerId,
      jobId,
      amount,
      { from: client }
    );

    const allowance = await tokenInstance.balanceOf(paymentInstance.address);
    // console.log("Allowance for Payment contract:", allowance.toString());

    truffleAssert.eventEmitted(result, "PaymentInitiated");
  });

  it("should complete a payment", async () => {
    const result = await paymentInstance.completePayment(0, { from: client });

    truffleAssert.eventEmitted(result, "PaymentCompleted");
  });

  it("should restrict refund to pending payments only", async () => {
    try {
      await paymentInstance.refundPayment(0, { from: client });
      assert.fail("Should not allow refunding a completed payment");
    } catch (error) {
      assert.equal(
        error.reason,
        "Payment is not in the correct status",
        "Expected revert message not found"
      );
    }
  });
});
