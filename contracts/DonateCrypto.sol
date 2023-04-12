// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

struct Campaign {
    address author;
    string title;
    string description;
    string videoUrl;
    string imageUrl;
    uint256 balance;
    bool active;
}

contract DonateCrypto {
    uint256 public fee = 100;
    mapping(uint256 => Campaign) public campaigns;

    /**
     * @dev Add a new campaign
     * @param title Title of the campaign
     * @param description Description of the campaign
     * @param videoUrl Video URL of the campaign
     * @param imageUrl Image URL of the campaign
     */
    function addCampaign(
        string calldata title,
        string calldata description,
        string calldata videoUrl,
        string calldata imageUrl
    ) public {
        Campaign memory newCampaign;
        newCampaign.title = title;
        newCampaign.description = description;
        newCampaign.videoUrl = videoUrl;
        newCampaign.imageUrl = imageUrl;
        newCampaign.author = msg.sender;
        newCampaign.active = true;

        uint256 id = block.timestamp;
        campaigns[id] = newCampaign;
    }

    function donate(uint256 id) public payable {
        require(msg.value > 0, "Value must be greater than 0");
        require(campaigns[id].active, "Campaign is not active");

        campaigns[id].balance += msg.value;
    }

    function withdraw(uint256 id) public {
        Campaign memory campaign = campaigns[id];

        require(campaign.author == msg.sender, "Only author can withdraw");
        require(campaign.active, "Campaign is not active");
        require(campaign.balance > fee, "Balance must be greater than fee");

        address payable recipient = payable(campaign.author);
        recipient.call{value: campaign.balance - fee}("");

        campaigns[id].active = false;
    }
}
