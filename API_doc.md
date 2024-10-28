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
