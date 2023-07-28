// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Degen is ERC20, ERC20Burnable, Ownable {
    struct StoreItem {
        uint256 itemId;
        string name;
        uint256 price;
    }

    // Mapping to store the store items by their ID
    mapping(uint256 => StoreItem) public storeItems;

    // Current item ID (will be used for the next item)
    uint256 public currentItemId;

    // Array to store the list of item IDs
    uint256[] public itemIds;

    // Mapping to store the items owned by each address and its quantity
    mapping(address => mapping(uint256 => uint256)) public myItems;

    constructor() ERC20("Degen", "DGN") {
        currentItemId = 1;
    }

    // Override decimals to set it to 0
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    // Allows the contract owner to create new tokens and assign them to a specified address
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function to add a new item to the store
    function addStoreItem(string memory itemName, uint256 itemPrice) public onlyOwner {
        uint256 itemId = currentItemId;
        storeItems[itemId] = StoreItem(itemId, itemName, itemPrice);
        itemIds.push(itemId);
        currentItemId++;
    }

    // Function to view all store items
    function viewStoreItems() public view returns (string[] memory) {
        uint256 totalItems = itemIds.length;
        string[] memory itemDetails = new string[](totalItems);

        for (uint256 i = 0; i < totalItems; i++) {
            uint256 itemId = itemIds[i];
            StoreItem memory item = storeItems[itemId];
            string memory details = string(abi.encodePacked(item.name, " - Price: ", uintToStr(item.price)));
            itemDetails[i] = details;
        }

        return itemDetails;
    }

    // Function to buy a store item using tokens
    function buyStoreItem(uint256 itemId) public {
        StoreItem memory item = storeItems[itemId];
        require(item.itemId > 0, "Invalid item ID");
        require(balanceOf(msg.sender) >= item.price, "Insufficient balance");

        // Transfer tokens from the buyer to the contract owner
        _transfer(msg.sender, owner(), item.price);

        // Increment the quantity of the item owned by the user
        myItems[msg.sender][itemId]++;
    }

    // Function to view the items and their quantities owned by a user
    function getMyItems() public view returns (string[] memory, uint256[] memory) {
        uint256 totalUserItems = itemIds.length;
        string[] memory itemNames = new string[](totalUserItems);
        uint256[] memory quantities = new uint256[](totalUserItems);

        for (uint256 i = 0; i < totalUserItems; i++) {
            uint256 itemId = itemIds[i];
            StoreItem memory item = storeItems[itemId];
            itemNames[i] = item.name;
            quantities[i] = myItems[msg.sender][itemId];
        }

        return (itemNames, quantities);
    }

    // Helper function to convert uint256 to string
    function uintToStr(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }
}
