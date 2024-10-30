# Payment Smart Contract

## Overview

The `Payment` smart contract facilitates financial transactions between clients and freelancers. It manages the escrow of payments associated with job contracts, ensures payment completion upon job fulfillment, and handles refunds in case of disputes.

## Functions

### 1. `initiatePayment`

Initiates a payment transaction, transferring funds from a client to an escrow to be held until job completion.

- **Parameters**:

  - `clientId` (`uint256`): The unique identifier of the client initiating the payment.
  - `freelancerId` (`uint256`): The unique identifier of the freelancer who will receive the payment upon job completion.
  - `jobId` (`uint256`): The unique identifier of the job associated with the payment.
  - `amount` (`uint256`): The amount of tokens to be transferred to the escrow.

- **Returns**: None.
- **Events**:
  - `PaymentInitiated`: Emitted when a payment is successfully initiated. Includes payment details such as payment ID, job ID, amounts, and participant IDs.

---

### 2. `completePayment`

Releases funds from escrow to the freelancer once the job is confirmed complete.

- **Parameters**:

  - `paymentId` (`uint256`): The unique identifier of the payment to be completed.

- **Returns**: None.
- **Events**:
  - `PaymentCompleted`: Emitted when a payment is completed, indicating the payment ID.

---

### 3. `refundPayment`

Refunds the escrowed funds back to the client in cases where the job is not completed as per the agreed terms.

- **Parameters**:

  - `paymentId` (`uint256`): The unique identifier of the payment to be completed.

- **Returns**: None.
- **Events**:
  - `PaymentRefunded`: Emitted when a payment is refunded to the client, specifying the payment ID.

---

### 4. `getCurrentStatus`

Provides the current status of a specified payment, indicating whether it is pending, completed, or refunded.

- **Parameters**:

  - `paymentId` (`uint256`): The unique identifier of the payment to be completed.

- **Returns**:
  - `PaymentStatus`: The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).

---

### 5. `getPaymentDetails`

Retrieves detailed information about a specific payment, including participant IDs, job ID, amount, and current balance.

- **Parameters**:

  - `paymentId` (`uint256`): The unique identifier of the payment to be completed.

- **Returns**:
  - Tuple containing:
    - `clientId` (`uint256`): The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).
    - `freelancerId` (`uint256`): The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).
    - `jobId` (`uint256`): The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).
    - `amount` (`uint256`): The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).
    - `balance` (`uint256`): The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).
    - `status` (`PaymentStatus`): The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).

---

## Events

### `PaymentInitiated`

Emitted when a new payment is initiated and funds are transferred to escrow.

- **Parameters**:
  - `paymentId` (`uint256`): The unique identifier of the payment.
  - `jobId` (`uint256`): Associated job ID.
  - `freelancerId` (`uint256`): ID of the freelancer.
  - `clientId` (`uint256`): ID of the client.
  - `amount` (`uint256`): Amount transferred to escrow.

---

### `PaymentCompleted`

Emitted when a payment is completed and funds are released to the freelancer.

- **Parameters**:
  - `paymentId` (`uint256`): The unique identifier of the completed payment.

---

### `PaymentRefunded`

Emitted when a payment is refunded to the client.

- **Parameters**:
  - `paymentId` (`uint256`): The unique identifier of the refunded payment.

# ResumeReviews Smart Contract

## Overview

The `ResumeReviews` smart contract allows users to store their work experience and receive reviews, creating a transparent and immutable work history on the blockchain. The contract also includes a reputation system based on user reviews.

## Functions

### 1. `addWorkExperience`

Adds a new work experience entry to the calling user's profile.

- **Parameters**:

  - `jobTitle` (`string`): The title of the job (e.g., "Software Engineer").
  - `description` (`string`): A description of the role and responsibilities.
  - `startDate` (`uint256`): The start date of the job in UNIX timestamp format.
  - `endDate` (`uint256`): The end date of the job in UNIX timestamp format.
  - `skills` (`string[]`): An array of skills used or developed during the job.

- **Returns**: None.
- **Events**:
  - `WorkExperienceAdded`: Emitted when a user adds a work experience. Includes the user’s address and the job title.

---

### 2. `addReview`

Adds a review for a specific user and updates their reputation score.

- **Parameters**:

  - `reviewee` (`address`): The address of the user being reviewed.
  - `rating` (`uint8`): The rating given, from 1 to 5.
  - `comment` (`string`): A comment describing the review.

- **Returns**: None.
- **Requirements**:

  - `rating` must be between 1 and 5.

- **Events**:
  - `ReviewSubmitted`: Emitted when a review is submitted, containing the reviewer’s address, reviewee’s address, and rating.

---

### 3. `getWorkHistory`

Returns the complete work history of a specified user.

- **Parameters**:

  - `user` (`address`): The address of the user whose work history is being requested.

- **Returns**:
  - `WorkExperience[]`: An array of `WorkExperience` structs for the specified user, each containing:
    - `jobTitle` (`string`)
    - `description` (`string`)
    - `startDate` (`uint256`)
    - `endDate` (`uint256`)
    - `skills` (`string[]`)

---

### 4. `getReviews`

Retrieves all reviews associated with a specified user.

- **Parameters**:

  - `user` (`address`): The address of the user whose reviews are being requested.

- **Returns**:
  - `Review[]`: An array of `Review` structs for the specified user, each containing:
    - `reviewer` (`address`): The address of the person who left the review.
    - `rating` (`uint8`): The rating given, from 1 to 5.
    - `comment` (`string`): A comment left by the reviewer.
    - `timestamp` (`uint256`): The UNIX timestamp when the review was created.

---

### 5. `getReputationScore`

Fetches the reputation score of a specified user.

- **Parameters**:

  - `user` (`address`): The address of the user whose reputation score is being requested.

- **Returns**:
  - `uint256`: The average reputation score for the user, calculated from the ratings in their reviews.

---

## Events

### `WorkExperienceAdded`

Emitted when a user adds a work experience.

- **Parameters**:
  - `user` (`address`): The address of the user adding work experience.
  - `jobTitle` (`string`): The title of the job being added.

---

### `ReviewSubmitted`

Emitted when a review is submitted for a user.

- **Parameters**:
  - `reviewer` (`address`): The address of the reviewer.
  - `reviewee` (`address`): The address of the person being reviewed.
  - `rating` (`uint8`): The rating provided in the review.

---

# JobListing Smart Contract

The `JobListing` smart contract allows clients to post job listings and freelancers to bid on them. It manages the entire lifecycle of a job, including listing, bidding, completion, and cancellation.

## Key Features

- Users can create job listings with descriptions and payment amounts
- Freelancers can bid on open job listings
- Clients can update job details after listing
- Payments are initiated automatically upon job completion
- Jobs can be cancelled by clients

## Functions

### 1. `listJob`

Creates a new job listing.

- **Parameters**:

  - `clientId`: The address of the client posting the job.
  - `description`: A description of the job.
  - `paymentAmount`: The amount to be paid for completing the job.

- **Modifiers**:

  - `onlyClient(clientId)`: Ensures only the client can list a job.

- **Events**:
  - `JobListed`: Emitted when a new job is listed, including the job ID, client ID, description, and payment amount.

---

### 2. `updateJob`

Updates existing job details.

- **Parameters**:

  - `jobId`: The ID of the job to update.
  - `description`: An updated description of the job.
  - `paymentAmount`: An updated payment amount for the job.

- **Modifiers**:

  - `onlyClient(jobs[jobId].clientId)`: Ensures only the client who listed the job can update it.

- **Requirements**:

  - The job must be open to allow updates.

- **Events**:
  - `JobUpdated`: Emitted when job details are updated, including the job ID, new description, and new payment amount.

---

### 3. `bidJob`

Allows freelancers to place bids on open job listings.

- **Parameters**:

  - `jobId`: The ID of the job being bid on.
  - `freelancerId`: The address of the freelancer placing the bid.

- **Modifiers**:

  - `require(userContract.isUserType(freelancerId, UserType.FREELANCER))`: Ensures only freelancers can bid.
  - `require(jobs[jobId].status == JobStatus.OPEN)`: Ensures the job is open for bidding.

- **Actions**:

  - Initiates escrow service payment for the completed job using the Payment contract.
  - Updates the job status to IN_PROGRESS.

- **Events**:
  - `JobBidded`: Emitted when a freelancer places a successful bid, including the job ID and freelancer ID.

---

### 4. `completeJob`

Marks a job as completed.

- **Parameters**:

  - `jobId`: The ID of the job to mark as completed.

- **Modifiers**:

  - `require(job.status == JobStatus.IN_PROGRESS)`: Ensures the job is in progress before allowing completion.
  - `require(msg.sender == userContract.getAddressFromUserId(job.freelancerId))`: Ensures only the assigned freelancer can complete the job.

- **Action**:

  - Updates the job status to COMPLETED.

- **Event**:
  - `JobCompleted`: Emitted when a job is marked as completed, including the job ID and freelancer ID.

---

### 5. `cancelJob`

Allows clients to cancel a job listing.

- **Parameters**:

  - `jobId`: The ID of the job to cancel.

- **Modifiers**:

  - `onlyClient(jobs[jobId].clientId)`: Ensures only the client who listed the job can cancel it.

- **Requirement**:

  - The job must be open to allow cancellation.

- **Action**:

  - Updates the job status to CANCELLED.

- **Event**:
  - `JobCancelled`: Emitted when a job is cancelled, including the job ID.

---

### 6. `getJobDetails`

Retrieves detailed information about a specific job.

- **Parameters**:

  - `jobId`: The ID of the job whose details are being retrieved.

- **Return Values**:
  - `uint256 jobId`: The unique identifier of the job.
  - `uint256 clientId`: The address of the client who posted the job.
  - `uint256 freelancerId`: The address of the freelancer assigned to the job (0 if unassigned).
  - `string memory description`: A description of the job.
  - `uint256 paymentAmount`: The amount to be paid for completing the job.
  - `JobStatus status`: The current status of the job.

This smart contract provides a comprehensive system for managing job listings, bidding, and payments within a decentralized platform. It integrates with other contracts (User and Payment) to ensure proper user types and secure financial transactions.

---
