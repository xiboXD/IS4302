# Freelancing Platform on Blockchain

## Overview
This is a decentralized freelancing platform built using Solidity on the Remix IDE. It integrates a payment system, a smart contract-based legally binding agreement, and a governance model for freelancers. The platform will allow users to hire freelancers, review their work history, and pay them using platform-native tokens. Freelancers will be able to vet new joiners and earn tokens based on completed tasks, contributing to the overall community governance.

## Features

### 1. **Version Control**
- We will use GitHub for version control to maintain the Solidity code and any associated documentation.

### 2. **Smart Contract for Legally Binding Agreements & Escrow Service**
- **Escrow System**: When both parties agree on job details and payment terms, the contract generates a legally binding agreement, securing funds in escrow. 
- **Job Completion**: The smart contract ensures that payment is released only when both parties confirm job completion.
- **Procurement & Anti-Corruption**: The agreement will include mechanisms for quality control and method of delivery, ensuring fairness and transparency.
  
### 3. **Payment System**
- **Platform Tokens**: Freelancers are paid using the platform's native tokens.
- **Token Incentives**: Freelancers can earn tokens for completing tasks, and for vetting potential freelancers wanting to join the community.
- **Escrow Contract**: The agreed payment amount is locked in the smart contract and is only released when both parties agree.

### 4. **On-chain Resume & Customer Reviews**
- **Immutable Work History**: Freelancers’ work history, including client testimonials and completed projects, is stored on-chain, making it tamper-proof.
- **Reviews**: Customers can leave feedback that contributes to the freelancer's reputation.
- **Incentivized Review System**: Encourage users to leave constructive feedback by offering token rewards.
  
### 5. **Governance (Voting)**
- **Token-Based Voting**: Token holders can vote on platform proposals such as resource allocation or system updates.
- **Proposal Creation**: Any token holder can submit a proposal to the platform governance.
  
## Potential Use Cases
1. **Freelancing Platform**: Smart contracts enable automated agreements between freelancers and clients, with a transparent payment system.
2. **Crowdfunding Platform**: Users can contribute to projects using crypto, and funds are released based on milestones tracked by smart contracts.
3. **Decentralized Voting System**: Users can participate in decision-making by voting, ensuring transparency and fairness.
4. **Charity Donation Tracking**: Blockchain ensures that charitable donations are tracked and used appropriately.
5. **Supply Chain Tracking**: Ensure transparency and verification at each stage of the supply chain.

## Mockup
The frontend of this project will feature a simple interface that allows users to:
- View freelancers' profiles, work history, and customer reviews.
- Submit job details, agree on terms, and initiate the smart contract.
- Vote on platform proposals.

*Note: This frontend is only a mockup and will not be connected to the backend (smart contract).*

## Roles & Perspectives
- **Freelancer**: Can join the platform, complete tasks, earn tokens, and vet new freelancers.
- **Client**: Can hire freelancers, review completed work, and release payments via the escrow system.
- **Admin/Platform Owner**: Manages governance and ensures smooth platform operation. Proposes platform updates.

## Legal Considerations
- The platform employs a smart contract system to generate legally binding agreements between freelancers and clients.
- The use of blockchain ensures that all transactions and agreements are secure, transparent, and immutable.

## Smart Contracts
- **Escrow Contract**: Locks in the payment when the job starts and releases it upon job completion.
- **Governance Contract**: Manages proposals and voting rights based on token holdings.
- **Review Contract**: Handles customer reviews and ratings.

## How to Use the Platform
1. **Create an Account**: Both freelancers and clients register on the platform.
2. **Post or Apply for Jobs**: Clients post job details; freelancers can apply.
3. **Smart Contract Agreement**: Once a freelancer is selected, a smart contract is automatically generated, locking in the agreed payment.
4. **Job Completion**: When the job is completed, both parties must confirm, and the escrow contract releases the payment.

## Tokenomics
- **Platform Token**: Used for payments, voting, and incentives. Tokens are earned for task completion and community contributions.

## Future Development
- **Crowdfunding Integration**: Allow projects to be funded via crypto, releasing funds through smart contracts based on milestones.
- **Advanced Governance**: Implement more sophisticated governance systems based on token ownership and community voting.
- **Multi-Signature Wallets**: Allow multiple parties to approve transactions, enhancing security.

## Contributors
- **Shirley**: Payment system, legally binding agreements, and token incentives.
- **Dzikril**: Resume and customer review system, incentivizing on-chain reputation.
- **Jaron**: System governance and voting structure.

---

### Notes
If time constraints arise, we will complete 80% of the core system. For the remaining 20%, we will provide detailed documentation explaining how to implement the rest in future updates.
