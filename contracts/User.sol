pragma solidity ^0.5.0;

contract User {
    enum UserType {
        Freelancer,
        Client,
        Reviewer
    }

    struct UserProfile {
        UserType userType;
        string username;
        string name;
        string email;
        uint256 rating;
    }

    address private owner;
    mapping(uint256 => UserProfile) private users;
    mapping(address => mapping(uint256 => uint256)) private addressToUserTypeId;
    mapping(uint256 => address) private userIdToAddress;
    mapping(string => uint256) private usernamesToUserId;
    uint256 private numUsers;

    constructor() public {
        owner = msg.sender;
    }

    event NewUserRegistered(uint256 userId, UserType userType);
    event UserProfileUpdated(uint256 userId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the contract owner");
        _;
    }

    function register(
        UserType userType,
        string memory username,
        string memory name,
        string memory email
    ) public {
        require(usernamesToUserId[username] == 0, "Username already exists.");
        require(
            addressToUserTypeId[msg.sender][uint(userType)] == 0,
            "User of this type already exists for this address."
        );

        // Create the new user profile
        UserProfile memory newUser = UserProfile({
            userType: userType,
            username: username,
            name: name,
            email: email,
            rating: 0
        });

        uint256 userId = numUsers++;
        users[userId] = newUser;
        addressToUserTypeId[msg.sender][uint(userType)] = userId;
        userIdToAddress[userId] = msg.sender; // populate the reverse mapping
        usernamesToUserId[username] = userId;

        emit NewUserRegistered(userId, userType);
    }

    function updateUserDetails(
        uint256 userId,
        string memory name,
        string memory email
    ) public {
        require(
            userIdToAddress[userId] == msg.sender,
            "Only the user can update their details."
        );
        users[userId].name = name;
        users[userId].email = email;

        emit UserProfileUpdated(userId);
    }

    function getUserDetails(
        uint256 userId
    )
        public
        view
        returns (
            UserType userType,
            string memory username,
            string memory name,
            string memory email,
            uint256 rating
        )
    {
        require(userId < numUsers, "Invalid user ID");
        UserProfile storage user = users[userId];
        return (
            user.userType,
            user.username,
            user.name,
            user.email,
            user.rating
        );
    }

    function isUser(address userAddress) public view returns (bool) {
        return
            addressToUserTypeId[userAddress][uint(UserType.Freelancer)] != 0 ||
            addressToUserTypeId[userAddress][uint(UserType.Client)] != 0 ||
            addressToUserTypeId[userAddress][uint(UserType.Reviewer)] != 0;
    }

    function isUserType(
        uint256 userId,
        UserType userType
    ) public view returns (bool) {
        require(userId < numUsers, "Invalid user ID");
        return users[userId].userType == userType;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
    }
}
