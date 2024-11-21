const truffleAssert = require("truffle-assertions");

const ResumeReviews = artifacts.require("ResumeReviews");
const User = artifacts.require("User");

contract("ResumeReviews", (accounts) => {
  let resumeReviewsInstance, userInstance;
  let freelancerId, clientId;

  const owner = accounts[0];
  const freelancer = accounts[1];
  const client = accounts[2];

  before(async () => {
    // Deploy the contracts
    userInstance = await User.deployed();
    resumeReviewsInstance = await ResumeReviews.deployed();
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

  it("should add work experience for a freelancer", async () => {
    const jobTitle = "Software Developer";
    const description = "Developed smart contracts";
    const startDate = Math.floor(Date.now() / 1000) - 10000; // 10,000 seconds ago
    const endDate = Math.floor(Date.now() / 1000); // Now
    const skills = ["Solidity", "JavaScript", "Truffle"];

    const result = await resumeReviewsInstance.addWorkExperience(
      freelancerId,
      jobTitle,
      description,
      startDate,
      endDate,
      skills,
      { from: freelancer }
    );

    truffleAssert.eventEmitted(result, "WorkExperienceAdded", (ev) => {
      return ev.userId.toNumber() === freelancerId && ev.jobTitle === jobTitle;
    });

    const workHistory = await resumeReviewsInstance.getWorkHistory(freelancerId);
    assert.equal(workHistory.length, 1, "Work experience was not added");
    assert.equal(
      workHistory[0].jobTitle,
      jobTitle,
      "Job title does not match"
    );
  });

  it("should add a review for a freelancer", async () => {
    const rating = 5;
    const comment = "Excellent work!";

    const result = await resumeReviewsInstance.addReview(
      clientId,
      freelancerId,
      rating,
      comment,
      { from: client }
    );


    const reviews = await resumeReviewsInstance.getReviews(freelancerId);
    assert.equal(reviews.length, 1, "Review was not added");
    assert.equal(reviews[0].rating, rating, "Rating does not match");
    assert.equal(reviews[0].comment, comment, "Comment does not match");
  });

  it("should update reputation score correctly", async () => {
    const reputationScore = await resumeReviewsInstance.getReputationScore(
      freelancerId
    );
    assert.equal(
      reputationScore.toNumber(),
      5,
      "Reputation score does not match the average rating"
    );
  });
});
