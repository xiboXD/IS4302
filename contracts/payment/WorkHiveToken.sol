pragma solidity ^0.5.0;

import "./ERC20.sol";
import "../User.sol"; // Import User contract

contract WorkHiveToken {
    ERC20 public erc20Contract;
    User public userContract;
    uint256 public supplyLimit;
    uint256 public currentSupply;
    uint256 public price;
    uint256 public numberOfUsers;
    address public owner;

    mapping(address => bool) public UsersWithTokens;
    mapping(address => bool) public Authorised;

    event NewAuthorisedAddress(address _address);
    event MintToken(address to, uint256 amount);
    event BurnToken(address to, uint256 amount);

    constructor(address _userAddress) public {
        ERC20 erc20 = new ERC20();
        erc20Contract = erc20;
        userContract = User(_userAddress);
        owner = msg.sender;
        currentSupply = 0;
        price = 1000000000000000000;
        Authorised[owner] = true;
        numberOfUsers = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You do not have permission to do this");
        _;
    }

    modifier onlyAuthorised() {
        require(
            Authorised[msg.sender],
            "You do not have permission to do this"
        );
        _;
    }

    modifier onlyRegisteredUser(address _address) {
        require(
            userContract.isUser(_address),
            "Address is not a registered user"
        );
        _;
    }

    function addAuthorised(address _address) public onlyOwner {
        Authorised[_address] = true;
        emit NewAuthorisedAddress(_address);
    }

    // Mint tokens
    function mintToken(uint256 amount, address _to) public onlyAuthorised {
        uint256 amtOfToken = amount / price;
        erc20Contract.mint(_to, amtOfToken);
        currentSupply += amtOfToken;
        if (!UsersWithTokens[_to]) {
            // New user
            numberOfUsers++;
            UsersWithTokens[_to] = true;
        }
        emit MintToken(_to, amtOfToken);
    }

    // Burn tokens
    function burnToken(uint256 amount, address _from) public {
        erc20Contract.burn(_from, amount);
        currentSupply -= amount;
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

    // check if address is authorized
    function checkAuthorised(address addr) public view returns (bool) {
        return Authorised[addr];
    }

    // Proxy transferFrom to erc20Contract for handling token transfers
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        return erc20Contract.transferFrom(from, to, amount);
    }

    // Proxy transferFrom to erc20Contract for handling token transfers
    function transfer(address to, uint256 amount) public returns (bool) {
        return erc20Contract.transfer(to, amount);
    }

    function approvedTransferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        return erc20Contract.approvedTransferFrom(from, to, amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        return erc20Contract.approve(spender, amount);
    }

    function balanceOf(address addr) public view returns (uint256) {
        return erc20Contract.balanceOf(addr);
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return erc20Contract.allowance(owner, spender);
    }
}
