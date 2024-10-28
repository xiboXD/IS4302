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
  - `paymentId` (`uint256`):     The unique identifier of the payment to be completed.

- **Returns**: None.
- **Events**:
  - `PaymentCompleted`: Emitted when a payment is completed, indicating the payment ID.

---

### 3. `refundPayment`
Refunds the escrowed funds back to the client in cases where the job is not completed as per the agreed terms.

- **Parameters**:
  - `paymentId` (`uint256`):     The unique identifier of the payment to be completed.

- **Returns**: None.
- **Events**:
  - `PaymentRefunded`: Emitted when a payment is refunded to the client, specifying the payment ID.

---

### 4. `getCurrentStatus`
Provides the current status of a specified payment, indicating whether it is pending, completed, or refunded.

- **Parameters**:
  - `paymentId` (`uint256`):     The unique identifier of the payment to be completed.

- **Returns**: 
  - `PaymentStatus`: The current status of the payment as an enum value (PAYMENT_PENDING, JOB_COMPLETE, REFUNDED).

---

### 5. `getPaymentDetails`
Retrieves detailed information about a specific payment, including participant IDs, job ID, amount, and current balance.

- **Parameters**:
  - `paymentId` (`uint256`):     The unique identifier of the payment to be completed.

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
