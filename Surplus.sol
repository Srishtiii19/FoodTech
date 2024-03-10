pragma solidity ^0.8.0;

contract EcoEats {
    // Define structures to represent food donations and organizations
    struct Donation {
        address donor;
        string foodItem;
        uint quantity;
        string location;
        uint pickUpTime;
        bool matched;
        bool pickedUp;
    }
    
    struct Organization {
        string name;
        string request;
        string location;
        bool active;
    }

    // Mapping to store donations and organizations
    mapping(uint => Donation) public donations;
    mapping(uint => Organization) public organizations;
    uint public donationCount;
    uint public organizationCount;
    
    // Events to track donation and matching status
    event DonationAdded(uint donationId);
    event DonationMatched(uint donationId, uint organizationId);
    event DonationPickedUp(uint donationId);

    // Function to add a new donation
    function addDonation(string memory _foodItem, uint _quantity, string memory _location, uint _pickUpTime) public {
        donationCount++;
        donations[donationCount] = Donation(msg.sender, _foodItem, _quantity, _location, _pickUpTime, false, false);
        emit DonationAdded(donationCount);
    }
    
    // Function to add a new organization
    function addOrganization(string memory _name, string memory _request, string memory _location) public {
        organizationCount++;
        organizations[organizationCount] = Organization(_name, _request, _location, true);
    }
    
    // Function to match a donation with an organization
    function matchDonation(uint _donationId, uint _organizationId) public {
        require(_donationId <= donationCount && _organizationId <= organizationCount);
        require(!donations[_donationId].matched && !donations[_donationId].pickedUp && organizations[_organizationId].active);
        
        donations[_donationId].matched = true;
        emit DonationMatched(_donationId, _organizationId);
    }
    
    // Function to confirm pick-up of a donation by an organization
    function confirmPickUp(uint _donationId) public {
        require(_donationId <= donationCount);
        require(donations[_donationId].matched && !donations[_donationId].pickedUp);
        
        donations[_donationId].pickedUp = true;
        emit DonationPickedUp(_donationId);
    }
}
