const truffleAssert = require("truffle-assertions");

const JobListing = artifacts.require("JobListing");
const User = artifacts.require("User");
const Payment = artifacts.require("Payment");

contract("JobListing", (accounts) => {
  let jobListingInstance, userInstance, paymentInstance;
  let clientId, freelancerId;

  const owner = accounts[0];
  const client = accounts[1];
  const freelancer = accounts[2];

  before(async () => {
    // Deploy the contracts
    userInstance = await User.deployed();
    paymentInstance = await Payment.deployed();
    jobListingInstance = await JobListing.new(userInstance.address, paymentInstance.address);

    // Register a client user
    const clientRegister = await userInstance.register(
      1, // UserType.Client
      "client1",
      "Client User",
      "client1@example.com",
      { from: client }
    );
    clientId = clientRegister.logs[0].args.userId.toNumber();

    // Register a freelancer user
    const freelancerRegister = await userInstance.register(
      0, // UserType.Freelancer
      "freelancer1",
      "Freelancer User",
      "freelancer1@example.com",
      { from: freelancer }
    );
    freelancerId = freelancerRegister.logs[0].args.userId.toNumber();
  });

  it("should list a job by the client", async () => {
    const description = "Develop a smart contract";
    const paymentAmount = web3.utils.toWei("1", "ether");

    const result = await jobListingInstance.listJob(
      clientId,
      description,
      paymentAmount,
      { from: client }
    );


    const jobDetails = await jobListingInstance.getJobDetails(1);
    assert.equal(jobDetails[1].toNumber(), clientId, "Client ID does not match");
    assert.equal(jobDetails[3], description, "Job description does not match");
    assert.equal(jobDetails[4], paymentAmount, "Payment amount does not match");
  });

  it("should update a job by the client", async () => {
    const newDescription = "Update contract with new features";
    const newPaymentAmount = web3.utils.toWei("1.5", "ether");

    const result = await jobListingInstance.updateJob(
      1,
      newDescription,
      newPaymentAmount,
      { from: client }
    );


    const jobDetails = await jobListingInstance.getJobDetails(1);
    assert.equal(jobDetails[3], newDescription, "Updated description does not match");
    assert.equal(jobDetails[4], newPaymentAmount, "Updated payment amount does not match");
  });

  it("should allow a freelancer to bid on a job", async () => {
    const result = await jobListingInstance.bidJob(
      0,
      1,
    );

    const jobDetails = await jobListingInstance.getJobDetails(1);
    assert.equal(jobDetails[2].toNumber(), freelancerId, "Freelancer ID does not match");
    assert.equal(jobDetails[5].toString(), "1", "Job status is not IN_PROGRESS");
  });

  it("should allow the freelancer to complete the job", async () => {
    const result = await jobListingInstance.completeJob(
      1
    );


    const jobDetails = await jobListingInstance.getJobDetails(1);
    assert.equal(jobDetails[5].toString(), "2", "Job status is not COMPLETED");
  });

  it("should allow the client to cancel an open job", async () => {
    // List another job
    await jobListingInstance.listJob(
      clientId,
      "Another contract development",
      web3.utils.toWei("2", "ether"),
      { from: client }
    );

    const result = await jobListingInstance.cancelJob(2, { from: client });


    const jobDetails = await jobListingInstance.getJobDetails(2);
    assert.equal(jobDetails[5].toString(), "3", "Job status is not CANCELLED");
  });
});
