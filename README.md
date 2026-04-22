# UE23CS342BA5-BLOCKCHAIN-MINI-PROJECT

# Blockchain-Based Food Donation Tracking System

A decentralized application (DApp) built using blockchain technology to reduce food wastage by enabling secure, transparent, and tamper-proof food donation tracking.

This project allows donors such as hostels, cafeterias, restaurants, and NGOs to donate surplus food, while receivers such as students, volunteers, and NGOs can claim and confirm pickup using smart contracts deployed on Ethereum Sepolia Testnet.

---

## Project Objective

The main objective of this project is to reduce food wastage and improve transparency in food donation using blockchain technology.

This system helps to:

- Reduce food wastage
- Ensure fair food distribution
- Prevent fake claims
- Maintain transparent records
- Remove dependency on centralized administration

---

## Team Members

### Member 1

**Name:** Drishti Golchha  
**SRN:** PES2UG23CS185

### Member 2

**Name:** Fairly Sorathiya  
**SRN:** PES2UG23CS189

---

## Technology Stack

| Component | Technology Used |
|---|---|
| Smart Contract | Solidity |
| Blockchain Platform | Ethereum |
| Test Network | Sepolia Testnet |
| Development IDE | Remix IDE |
| Wallet Integration | MetaMask |

---

## Features

### 1. Create Donation

Donors can post surplus food details to the blockchain.

### 2. Claim Donation

Receivers can claim available food donations.

### 3. Confirm Pickup

Receivers confirm successful food collection.

### 4. View Donation Details

Users can track donation details such as donor, receiver, and status.

### 5. Blockchain Ledger

Every donation, claim, and pickup is permanently stored on the blockchain.

### 6. Secure Smart Contract Validation

Only valid users can perform specific actions based on contract rules.

---

** Smart Contract Functions**
 createDonation()

Used by donor to create a food donation.

createDonation("Burger")
claimDonation()
Used by receiver to claim a donation.

claimDonation(1)
confirmPickup()
Used by receiver to confirm food pickup.

confirmPickup(1)
getDonation()
Used to fetch donation details.

getDonation(1)
Workflow
Step 1 — Donor Creates Donation
Account 1 creates a donation:

createDonation("Rice Packets")
Status becomes: Available

Step 2 — Receiver Claims Donation
Account 2 or Account 3 claims the donation:

claimDonation(1)
Status becomes: Claimed

Step 3 — Receiver Confirms Pickup
The same receiver confirms pickup:

confirmPickup(1)
Status becomes: PickedUp

**Smart Contract Security**

Donor Cannot Claim Own Donation

require(msg.sender != donor, "Donor cannot claim");

Already Claimed Donations Cannot Be Claimed Again

require(status == Status.Available, "Already claimed");

Only Receiver Can Confirm Pickup

require(msg.sender == receiver, "Only receiver can confirm");

Deployment Steps
Step 1
Open Remix IDE

Step 2
Paste Solidity smart contract code

Step 3
Compile using Solidity Compiler

Step 4
Open MetaMask and switch to:

Sepolia Testnet
Step 5
Get free Sepolia ETH using faucet

Step 6
In Remix select:

Browser Extension / Injected Provider
Step 7
Connect MetaMask wallet

Step 8
Deploy contract and confirm transaction

Testing
Test Case 1
Create donation using Account 1

createDonation("Burger")
Test Case 2
Claim donation using Account 3

claimDonation(1)
Test Case 3
Confirm pickup using same receiver account

confirmPickup(1)
Test Case 4
Check donation details

getDonation(1)
Type of Blockchain
This project uses a:

Public Blockchain
Specifically:

Ethereum Sepolia Testnet
Because it provides:

Transparency

Security

Decentralization

Public verification

Consensus Algorithm
This project uses Ethereum’s:

Proof of Stake (PoS)
Why PoS?
Energy efficient

Secure validation

Decentralized verification

Faster transaction confirmation

Better scalability than Proof of Work

Conclusion
The Blockchain-Based Food Donation Tracking System successfully demonstrates how blockchain technology can improve trust, transparency, and accountability in food donation processes.

The project removes the need for a central administrator and ensures secure donation tracking using smart contracts and MetaMask integration.

It provides a practical and scalable solution for reducing food wastage and helping people in need through decentralized food redistribution.
