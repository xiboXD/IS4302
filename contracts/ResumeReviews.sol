// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./User.sol";

contract ResumeReviews {
    User public userContract;

    struct WorkExperience {
        string jobTitle;
        string description;
        uint256 startDate;
        uint256 endDate;
        string[] skills;
    }

    struct Review {
        address reviewer;
        uint8 rating;
        string comment;
        uint256 timestamp;
    }

    struct UserProfile {
        WorkExperience[] workHistory;
        Review[] reviews;
        uint256 reputationScore;
    }

    mapping(uint256 => UserProfile) public users; // Changed to use userId instead of address

    event WorkExperienceAdded(uint256 indexed userId, string jobTitle); // Changed to use userId instead of address
    event ReviewSubmitted(uint256 indexed reviewerId, uint256 indexed revieweeId, uint8 rating); // Changed to use userId instead of address

    constructor(address userAddress) {
        userContract = User(userAddress);  // Initialize the User contract
    }

    function addWorkExperience(
        uint256 userId,
        string memory jobTitle,
        string memory description,
        uint256 startDate,
        uint256 endDate,
        string[] memory skills
    ) public {
        require(userContract.isUserType(userId, User.UserType.Freelancer), "Only freelancers can add work experience.");
        require(userContract.getAddressFromUserId(userId) == msg.sender, "Unauthorized access.");

        WorkExperience memory newExperience = WorkExperience({
            jobTitle: jobTitle,
            description: description,
            startDate: startDate,
            endDate: endDate,
            skills: skills
        });

        users[userId].workHistory.push(newExperience);
        emit WorkExperienceAdded(msg.sender, jobTitle);
    }

    function addReview(
        uint256 reviewerId,
        uint256 revieweeId,
        uint8 rating,
        string memory comment
    ) public {
        require(rating > 0 && rating <= 5, "Rating must be between 1 and 5");
        require(userContract.isUserType(reviewerId, User.UserType.Client), "Only clients can add reviews.");
        require(userContract.getAddressFromUserId(reviewerId) == msg.sender, "Unauthorized access");

        Review memory newReview = Review({
            reviewer: msg.sender,
            rating: rating,
            comment: comment,
            timestamp: block.timestamp
        });

        users[revieweeId].reviews.push(newReview);
        updateReputation(revieweeId);

        emit ReviewSubmitted(reviewerId, revieweeId, rating);
    }

    function updateReputation(uint256 userId) internal {
        uint256 totalScore = 0;
        Review[] memory userReviews = users[userId].reviews;

        for (uint256 i = 0; i < userReviews.length; i++) {
            totalScore += userReviews[i].rating;
        }

        users[userId].reputationScore = userReviews.length > 0
            ? totalScore / userReviews.length
            : 0;
    }

    function getWorkHistory(
        uint256 userId
    ) public view returns (WorkExperience[] memory) {
        return users[userId].workHistory;
    }

    function getReviews(uint256 userId) public view returns (Review[] memory) {
        return users[userId].reviews;
    }

    function getReputationScore(uint256 userId) public view returns (uint256) {
        return users[userId].reputationScore;
    }
}
