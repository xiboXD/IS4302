const User = artifacts.require("User");

contract("User", (accounts) => {
  let userInstance;

  const owner = accounts[0];
  const newOwner = accounts[1];
  const freelancerAccount = accounts[2];
  const clientAccount = accounts[3];

  before(async () => {
    userInstance = await User.deployed();
  });

  it("should set the contract deployer as the owner", async () => {
    const contractOwner = await userInstance.owner.call();
    assert.equal(contractOwner, owner, "Owner is not set to contract deployer");
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
      { from: freelancerAccount }
    );

    const userId = result.logs[0].args.userId.toNumber();
    assert.equal(
      result.logs[0].event,
      "NewUserRegistered",
      "NewUserRegistered event not emitted"
    );

    const userDetails = await userInstance.getUserDetails(userId);
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
      { from: clientAccount }
    );

    const userId = result.logs[0].args.userId.toNumber();
    assert.equal(
      result.logs[0].event,
      "NewUserRegistered",
      "NewUserRegistered event not emitted"
    );

    const userDetails = await userInstance.getUserDetails(userId);
    assert.equal(userDetails.username, username, "Usernames do not match");
    assert.equal(userDetails.name, name, "Names do not match");
    assert.equal(userDetails.email, email, "Emails do not match");
  });

  it("should allow a user to update their profile", async () => {
    const userId = 0;
    const newName = "Updated Name";
    const newEmail = "updated@example.com";

    await userInstance.updateUserDetails(userId, newName, newEmail, {
      from: freelancerAccount,
    });
    const updatedDetails = await userInstance.getUserDetails(userId);

    assert.equal(updatedDetails.name, newName, "Name was not updated");
    assert.equal(updatedDetails.email, newEmail, "Email was not updated");
  });

  it("should restrict profile updates to the user themselves", async () => {
    const userId = 0;
    try {
      await userInstance.updateUserDetails(
        userId,
        "Invalid",
        "invalid@example.com",
        { from: clientAccount }
      );
      assert.fail("Only the user should be able to update their details");
    } catch (error) {
      assert(
        error.message.includes("Only the user can update their details."),
        "Error message mismatch"
      );
    }
  });

  it("should return true if the user is a freelancer", async () => {
    const userId = 0;
    const isFreelancer = await userInstance.isFreelancer(userId);
    assert.isTrue(isFreelancer, "User should be a freelancer");
  });

  it("should return false for incorrect user type checks", async () => {
    const clientId = 1;
    const isFreelancer = await userInstance.isFreelancer(clientId);
    assert.isFalse(
      isFreelancer,
      "Client should not be identified as a freelancer"
    );

    const isClient = await userInstance.isClient(clientId);
    assert.isTrue(isClient, "User should be a client");
  });

  it("should transfer ownership of the contract", async () => {
    await userInstance.transferOwnership(newOwner, { from: owner });
    const updatedOwner = await userInstance.owner.call();
    assert.equal(
      updatedOwner,
      newOwner,
      "Ownership was not transferred to the new owner"
    );
  });

  it("should prevent non-owners from transferring ownership", async () => {
    try {
      await userInstance.transferOwnership(accounts[5], {
        from: freelancerAccount,
      });
      assert.fail("Only the owner should be able to transfer ownership");
    } catch (error) {
      assert(
        error.message.includes("Caller is not the contract owner"),
        "Error message mismatch"
      );
    }
  });
});
