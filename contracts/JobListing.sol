pragma solidity ^0.5.0;

import "./payment/Payment.sol";
import "./User.sol";

contract JobListing {
    address private owner;
    User public userContract;
    Payment public paymentContract;

    enum JobStatus {
        OPEN,
        IN_PROGRESS,
        COMPLETED,
        CANCELLED
    }

    struct Job {
        uint256 jobId;
        uint256 clientId;
        uint256 freelancerId;
        string description;
        uint256 paymentAmount;
        JobStatus status;
    }

    mapping(uint256 => Job) public jobs;
    uint256 public numJobs;

    event JobListed(
        uint256 indexed jobId,
        uint256 indexed clientId,
        string description,
        uint256 paymentAmount
    );
    event JobUpdated(
        uint256 indexed jobId,
        string description,
        uint256 paymentAmount
    );
    event JobBidded(uint256 indexed jobId, uint256 indexed freelancerId);
    event JobCompleted(uint256 indexed jobId, uint256 indexed freelancerId);
    event JobCancelled(uint256 indexed jobId);

    constructor(address _userContract, address _paymentContract) public {
        owner = msg.sender;
        userContract = User(_userContract);
        paymentContract = Payment(_paymentContract);
    }

    modifier onlyClient(uint256 clientId) {
        require(
            userContract.isClient(clientId),
            "Only clients can perform this action"
        );
        _;
    }

    function listJob(
        uint256 clientId,
        string memory description,
        uint256 paymentAmount
    ) public onlyClient(clientId) {
        numJobs++;
        jobs[numJobs] = Job({
            jobId: numJobs,
            clientId: clientId,
            freelancerId: 0,
            description: description,
            paymentAmount: paymentAmount,
            status: JobStatus.OPEN
        });

        emit JobListed(numJobs, clientId, description, paymentAmount);
    }

    function updateJob(
        uint256 jobId,
        string memory description,
        uint256 paymentAmount
    ) public onlyClient(jobs[jobId].clientId) {
        Job storage job = jobs[jobId];
        require(
            jobs[jobId].status == JobStatus.OPEN,
            "Job must be open to update"
        );

        job.description = description;
        job.paymentAmount = paymentAmount;

        emit JobUpdated(jobId, description, paymentAmount);
    }

    function bidJob(uint256 jobId, uint256 freelancerId) public {
        Job storage job = jobs[jobId];
        require(
            userContract.isFreelancer(freelancerId),
            "Only freelancers can bid"
        );
        require(
            jobs[jobId].status == JobStatus.OPEN,
            "Job is not open for bidding"
        );

        // Initiate escrow service payment to payment.sol for the job
        paymentContract.initiatePayment(
            job.clientId,
            job.freelancerId,
            jobId,
            job.paymentAmount
        );

        job.freelancerId = freelancerId;
        job.status = JobStatus.IN_PROGRESS;

        emit JobBidded(jobId, freelancerId);
    }

    function completeJob(uint256 jobId) public {
        Job storage job = jobs[jobId];
        require(job.status == JobStatus.IN_PROGRESS, "Job is not in progress");
        require(
            msg.sender == userContract.getAddressFromUserId(job.freelancerId),
            "Only the assigned freelancer can complete the job"
        );

        job.status = JobStatus.COMPLETED;

        emit JobCompleted(jobId, job.freelancerId);
    }

    function cancelJob(uint256 jobId) public onlyClient(jobs[jobId].clientId) {
        Job storage job = jobs[jobId];
        require(job.status == JobStatus.OPEN, "Job is not open");

        job.status = JobStatus.CANCELLED;

        emit JobCancelled(jobId);
    }

    function getJobDetails(uint256 jobId) public view returns (uint256, uint256, uint256, string memory, uint256, JobStatus) {
        Job storage job = jobs[jobId];
        return (
            job.jobId,
            job.clientId,
            job.freelancerId,
            job.description,
            job.paymentAmount,
            job.status
        );
    }
}
