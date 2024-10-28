// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ResumeReviews {
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

    mapping(address => UserProfile) public users;
    
    event WorkExperienceAdded(address indexed user, string jobTitle);
    event ReviewSubmitted(address indexed reviewer, address indexed reviewee, uint8 rating);
    
    function addWorkExperience(
        string memory jobTitle, 
        string memory description, 
        uint256 startDate, 
        uint256 endDate, 
        string[] memory skills
    ) public {
        WorkExperience memory newExperience = WorkExperience({
            jobTitle: jobTitle,
            description: description,
            startDate: startDate,
            endDate: endDate,
            skills: skills
        });
        
        users[msg.sender].workHistory.push(newExperience);
        emit WorkExperienceAdded(msg.sender, jobTitle);
    }

    function addReview(address reviewee, uint8 rating, string memory comment) public {
        require(rating > 0 && rating <= 5, "Rating must be between 1 and 5");

        Review memory newReview = Review({
            reviewer: msg.sender,
            rating: rating,
            comment: comment,
            timestamp: block.timestamp
        });
        
        users[reviewee].reviews.push(newReview);
        updateReputation(reviewee);

        emit ReviewSubmitted(msg.sender, reviewee, rating);
    }

    function updateReputation(address user) internal {
        uint256 totalScore = 0;
        Review[] memory userReviews = users[user].reviews;
        
        for (uint256 i = 0; i < userReviews.length; i++) {
            totalScore += userReviews[i].rating;
        }
        
        users[user].reputationScore = userReviews.length > 0 ? totalScore / userReviews.length : 0;
    }

    function getWorkHistory(address user) public view returns (WorkExperience[] memory) {
        return users[user].workHistory;
    }

    function getReviews(address user) public view returns (Review[] memory) {
        return users[user].reviews;
    }

    function getReputationScore(address user) public view returns (uint256) {
        return users[user].reputationScore;
    }
}
