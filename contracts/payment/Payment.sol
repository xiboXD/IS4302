pragma solidity ^0.5.0;

import "./WorkHiveToken.sol";
import "../User.sol";

contract Payment {
    address private owner;
    User public userContract;
    WorkHiveToken public tokenContract;

    enum PaymentStatus {
        PAYMENT_PENDING,
        JOB_COMPLETE,
        REFUNDED
    }

    struct PaymentDetails {
        uint256 clientId;
        uint256 freelancerId;
        uint256 jobId;
        uint256 amount;
        uint256 balance;
        PaymentStatus status;
    }

    mapping(uint256 => PaymentDetails) public payments;
    uint256 private numPayments; // to track payment IDs

    event PaymentInitiated(
        uint256 indexed paymentId,
        uint256 indexed jobId,
        uint256 indexed freelancerId,
        uint256 clientId,
        uint256 amount
    );
    event PaymentCompleted(uint256 paymentId);
    event PaymentPartiallyRefunded(uint256 paymentId);
    event PaymentFullyRefunded(uint256 paymentId);

    constructor(address _userContract, address _tokenContract) public {
        owner = msg.sender;
        userContract = User(_userContract); // corrected reference to User contract
        tokenContract = WorkHiveToken(_tokenContract);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You do not have permission to do this");
        _;
    }

    function initiatePayment(
        uint256 clientId,
        uint256 freelancerId,
        uint256 jobId,
        uint256 amount
    ) public {
        require(
            userContract.isClient(clientId),
            "Only clients can initiate payments"
        );
        require(
            userContract.isFreelancer(freelancerId),
            "Payments must be made to freelancers"
        );

        tokenContract.transferFrom(
            userContract.getAddressFromUserId(clientId),
            address(this),
            amount
        );

        tokenContract.approve(address(this), amount);

        payments[numPayments] = PaymentDetails({
            clientId: clientId,
            freelancerId: freelancerId,
            jobId: jobId,
            amount: amount,
            balance: amount,
            status: PaymentStatus.PAYMENT_PENDING
        });

        emit PaymentInitiated(
            numPayments,
            jobId,
            freelancerId,
            clientId,
            amount
        );
        numPayments++; // increment payment count
    }

    function completePayment(uint256 paymentId) public {
        PaymentDetails storage payment = payments[paymentId];
        require(
            payment.status == PaymentStatus.PAYMENT_PENDING,
            "Payment is not in the correct status"
        );

        address freelancerAddress = userContract.getAddressFromUserId(
            payment.freelancerId
        );

        // Ensure Payment contract has enough tokens
        uint256 contractBalance = tokenContract.balanceOf(address(this));
        require(
            contractBalance >= payment.amount,
            "Payment contract balance too low"
        );

        // Transfer tokens to freelancer
        bool success = tokenContract.approvedTransferFrom(
            address(this),
            freelancerAddress,
            payment.amount
        );
        require(success, "Token transfer to freelancer failed");

        payment.balance = 0;
        payment.status = PaymentStatus.JOB_COMPLETE;

        emit PaymentCompleted(paymentId);
    }

    function refundPayment(uint256 paymentId) public {
        PaymentDetails storage payment = payments[paymentId];
        require(
            payment.status == PaymentStatus.PAYMENT_PENDING,
            "Payment is not in the correct status"
        );

        tokenContract.transfer(
            userContract.getAddressFromUserId(payment.clientId),
            payment.balance
        );
        payment.balance = 0;
        payment.status = PaymentStatus.REFUNDED;

        emit PaymentFullyRefunded(paymentId); // corrected event name
    }

    function getCurrentStatus(
        uint256 paymentId
    ) public view returns (PaymentStatus) {
        return payments[paymentId].status;
    }

    function getPaymentDetails(
        uint256 paymentId
    )
        public
        view
        returns (uint256, uint256, uint256, uint256, uint256, PaymentStatus)
    {
        PaymentDetails storage payment = payments[paymentId];
        return (
            payment.clientId,
            payment.freelancerId,
            payment.jobId,
            payment.amount,
            payment.balance,
            payment.status
        );
    }
}
