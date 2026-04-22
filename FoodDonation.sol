// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title FoodDonation
 * @notice Blockchain-based Food Donation Tracking System
 * @dev Consensus Algorithm: Proof of Stake (Ethereum Sepolia Testnet)
 *      PoS chosen because: energy efficient, fast finality,
 *      tamper-proof validation — ideal for transparent food redistribution.
 */
contract FoodDonation {

    // ── STATE VARIABLES ──────────────────────────────────────
    address public admin;
    uint public donationCount = 0;

    // ── ENUMS ────────────────────────────────────────────────
    enum Role { None, Donor, Beneficiary }
    enum Status { Available, Claimed, Completed, Cancelled }

    // ── STRUCTS ──────────────────────────────────────────────
    struct User {
        Role role;
        bool registered;
        string name;
    }

    struct Donation {
        uint id;
        address donor;
        string foodDetails;
        uint quantity;
        Status status;
        address claimedBy;
        uint timestamp;
    }

    // ── MAPPINGS ─────────────────────────────────────────────
    mapping(address => User) public users;
    mapping(uint => Donation) public donations;

    // ── EVENTS ───────────────────────────────────────────────
    event UserRegistered(address indexed user, Role role, string name);
    event DonationCreated(uint indexed id, address indexed donor, string foodDetails, uint quantity);
    event DonationClaimed(uint indexed id, address indexed claimedBy);
    event DonationCompleted(uint indexed id);
    event DonationCancelled(uint indexed id, address cancelledBy);

    // ── CONSTRUCTOR ──────────────────────────────────────────
    constructor() {
        admin = msg.sender;
    }

    // ── MODIFIERS ────────────────────────────────────────────
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyDonor() {
        require(users[msg.sender].role == Role.Donor, "Not a registered donor");
        _;
    }

    modifier onlyBeneficiary() {
        require(users[msg.sender].role == Role.Beneficiary, "Not a registered beneficiary");
        _;
    }

    modifier onlyAvailable(uint _id) {
        require(donations[_id].status == Status.Available, "Donation not available");
        _;
    }

    modifier validDonation(uint _id) {
        require(_id > 0 && _id <= donationCount, "Invalid donation ID");
        _;
    }

    // ── REGISTER ─────────────────────────────────────────────

    /// @notice Register yourself as Donor (Role=1) or Beneficiary (Role=2)
    function register(Role _role, string memory _name) public {
        require(!users[msg.sender].registered, "Already registered");
        require(_role == Role.Donor || _role == Role.Beneficiary, "Invalid role");
        users[msg.sender] = User(_role, true, _name);
        emit UserRegistered(msg.sender, _role, _name);
    }

    // ── CREATE DONATION ──────────────────────────────────────

    /// @notice Create donation without quantity (overload 1)
    function createDonation(string memory _foodDetails) public onlyDonor {
        donationCount++;
        donations[donationCount] = Donation(
            donationCount,
            msg.sender,
            _foodDetails,
            1,
            Status.Available,
            address(0),
            block.timestamp
        );
        emit DonationCreated(donationCount, msg.sender, _foodDetails, 1);
    }

    /// @notice Create donation with quantity (overload 2 — function overloading)
    function createDonation(string memory _foodDetails, uint _quantity) public onlyDonor {
        require(_quantity > 0, "Quantity must be at least 1");
        donationCount++;
        donations[donationCount] = Donation(
            donationCount,
            msg.sender,
            _foodDetails,
            _quantity,
            Status.Available,
            address(0),
            block.timestamp
        );
        emit DonationCreated(donationCount, msg.sender, _foodDetails, _quantity);
    }

    // ── CLAIM DONATION ───────────────────────────────────────

    /// @notice Beneficiary claims a donation — First Come First Serve
    function claimDonation(uint _id) public onlyBeneficiary validDonation(_id) onlyAvailable(_id) {
        donations[_id].status = Status.Claimed;
        donations[_id].claimedBy = msg.sender;
        emit DonationClaimed(_id, msg.sender);
    }

    // ── CONFIRM PICKUP ───────────────────────────────────────

    /// @notice Donor confirms the beneficiary picked up the food
    function confirmPickup(uint _id) public validDonation(_id) onlyDonor {
        require(msg.sender == donations[_id].donor, "Not your donation");
        require(donations[_id].status == Status.Claimed, "Not yet claimed");
        donations[_id].status = Status.Completed;
        emit DonationCompleted(_id);
    }

    // ── CANCEL DONATION ──────────────────────────────────────

    /// @notice Donor or Admin can cancel an unclaimed donation
    function cancelDonation(uint _id) public validDonation(_id) onlyAvailable(_id) {
        require(
            msg.sender == donations[_id].donor || msg.sender == admin,
            "Not authorized to cancel"
        );
        donations[_id].status = Status.Cancelled;
        emit DonationCancelled(_id, msg.sender);
    }

    // ── VIEW FUNCTIONS ───────────────────────────────────────

    /// @notice Get full details of a donation
    function getDonation(uint _id)
        public view validDonation(_id)
        returns (uint, address, string memory, uint, Status, address, uint)
    {
        Donation memory d = donations[_id];
        return (d.id, d.donor, d.foodDetails, d.quantity, d.status, d.claimedBy, d.timestamp);
    }

    /// @notice Get all currently available donation IDs
    function getAvailableDonations() public view returns (uint[] memory) {
        uint count = 0;
        for (uint i = 1; i <= donationCount; i++) {
            if (donations[i].status == Status.Available) count++;
        }
        uint[] memory result = new uint[](count);
        uint index = 0;
        for (uint i = 1; i <= donationCount; i++) {
            if (donations[i].status == Status.Available) {
                result[index++] = i;
            }
        }
        return result;
    }

    /// @notice Get user info
    function getUser(address _addr) public view returns (string memory, Role, bool) {
        User memory u = users[_addr];
        return (u.name, u.role, u.registered);
    }

    // ── ADMIN ────────────────────────────────────────────────

    /// @notice Transfer admin to another address
    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }

    // ── FALLBACK ─────────────────────────────────────────────
    fallback() external payable {}
    receive() external payable {}
}