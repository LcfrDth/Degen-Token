# Project: Degen Token (ERC-20): Unlocking the Future of Gaming

## Description

This code is a Solidity smart contract called "Degen" that represents a decentralized application (DApp) for a simple token-based store. The contract allows users to interact with the store by adding items, viewing available items, and buying items using their tokens. Users can also view the items they own and the quantities they have purchased.

Contract Address : 0x2107ecE415d8Fc3419ad385a9E10dAd15B6D5d2B

## Features

1. **ERC20 Token**: The smart contract extends the standard ERC20 token implementation provided by the OpenZeppelin library. It allows users to own, transfer, and manage the "Degen" tokens.

2. **Virtual Store**: The contract includes a virtual store that can be managed by the contract owner. The store allows users to buy items using their "Degen" tokens.

3. **Adding Items to Store**: The contract owner has the privilege to add new items to the store. Each item is associated with a name and a price in "Degen" tokens.

4. **Viewing Store Items**: Anyone can view the list of items available in the store along with their names and prices.

5. **Buying Items**: Users can buy items from the store using their "Degen" tokens. When a user purchases an item, the corresponding token amount is transferred from their balance to the contract owner.

6. **Tracking User's Items**: The contract keeps track of the items owned by each user and the quantity of each item they have bought.

7. **Burning Tokens**: Users have the option to burn (destroy) their own "Degen" tokens if they want to remove them from circulation.

## Contract Details

- **Token Name**: Degen
- **Token Symbol**: DGN

### Functions

1. `mint(address to, uint256 amount)`: Allows the contract owner to create new "Degen" tokens and assign them to a specified address.

2. `addStoreItem(string memory itemName, uint256 itemPrice)`: Adds a new item to the virtual store with the given name and price in "Degen" tokens.

3. `viewStoreItems()`: Retrieves an array of strings containing details of all the items available in the store, including their names and prices.

4. `buyStoreItem(uint256 itemId)`: Enables users to buy items from the store using their "Degen" tokens. The contract owner receives the payment, and the user's ownership of the item is recorded.

5. `getMyItems()`: Allows users to view the list of items they own and the corresponding quantities they possess.

6. `burn(uint256 amount)`: Allows users to burn (destroy) a specified amount of their own "Degen" tokens.

### Data Structures

- `StoreItem`: A struct representing an item in the store. It includes the item's ID, name, and price.

### Libraries

The contract uses the OpenZeppelin library to leverage existing implementations of the ERC20 standard and access control functionalities.

### Setting Up

Executing program
To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension.

```javascript

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


```


1. Get the code from the Solidity file or copy the code above.
2. Use a Solidity compiler or development environment of your choosing to compile the Solidity code.
3. Use a tool which is Remix to release the built contract on the Ethereum network of your choosing.

## Help

If you have any problems or queries when working with Solidity, see the relevant documentation for your compiler or development environment. Support from online Solidity developer groups or forums is also available.

## Authors

Mark Arceo - Mapua University
