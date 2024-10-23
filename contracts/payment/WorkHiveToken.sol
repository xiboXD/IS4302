pragma solidity ^0.5.0;

import "./ERC20.sol";

contract WorkHiveToken {
    ERC20 erc20Contract;
    uint256 supplyLimit;
    uint256 currentSupply;
    uint256 price;
    uint256 numberOfUsers;
    address owner;

    mapping(address => bool) UsersWithTokens;
    mapping(address => bool) Authorised;

    event NewAllowedAddress(address _recipient);
    event NewAuthorisedAddress(address _address);
    event MintToken(address to, uint256 amount);
    event BurnToken(address to, uint256 amount);

    constructor() public {
        ERC20 e = new ERC20();
        erc20Contract = e;
        owner = msg.sender;
        currentSupply = 0;
        price = 1000;
        Authorised[owner] = true;
        numberOfUsers = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You do not have permission to do this");
        _;
    }

    modifier onlyAuthorised() {
        require(
            Authorised[msg.sender] == true,
            "You do not have permission to do this"
        );
        _;
    }

    function addAuthorised(address _address) public onlyOwner {
        Authorised[_address] = true;
        emit NewAuthorisedAddress(_address);
    }

    // Mint tokens
    function mintToken(
        uint256 amount,
        address _to
    ) public onlyAuthorisedAddress {
        uint256 amtOfToken = amount / price;
        erc20Contract.mint(_to, amount);
        currentSupply = currentSupply + amount;
        if (UsersWithTokens[_to] == false) {
            // New user
            numberOfUsers = numberOfUsers + 1;
            UsersWithTokens[_to] = true;
        }
        emit MintToken(_to, amount);
    }

    // Burn tokens
    function burnToken(
        uint256 amount,
        address _from
    ) public onlyAuthorisedAddress {
        erc20Contract.burn(_from, amount);
        currentSupply = currentSupply - amount;
        emit BurnToken(_from, amount);
    }

    // Get current supply of tokens
    function getCurrentSupply() public view returns (uint256) {
        return currentSupply;
    }

    // Check current amount of users in the market
    function getNumberOfUsers() public view returns (uint256) {
        return numberOfUsers;
    }

    // get base price of tokens
    function getPrice() public view returns (uint256) {
        return price;
    }

    // check if address is authoried
    function checkAuthorised(address addr) public view returns (bool) {
        return Authorised[addr];
    }
}
