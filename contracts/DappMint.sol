// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title DappMint
 * @notice NFT Minting DApp Smart Contract
 * @dev ERC-721 Minting with Supply Limit + Mint Fee + Withdraw + Pause
 */

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DappMint is ERC721URIStorage, Ownable, Pausable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public maxSupply = 5000;
    uint256 public mintPrice = 0.01 ether;

    string public baseURI;

    constructor(string memory _baseURI) ERC721("DappMint", "DMNT") {
        baseURI = _baseURI;
    }

    // -------- Mint Function ----------
    function mintNFT(address recipient) public payable whenNotPaused {
        require(msg.value >= mintPrice, "Mint fee not paid!");
        require(_tokenIds.current() < maxSupply, "All NFTs minted!");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, string(abi.encodePacked(baseURI, "/", uint2str(newItemId), ".json")));
    }

    // -------- Owner Controls ----------
    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }

    function pauseMinting() external onlyOwner {
        _pause();
    }

    function resumeMinting() external onlyOwner {
        _unpause();
    }

    // -------- Withdraw Funds ----------
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // -------- Internal Helper ----------
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + (j % 10)));
            j /= 10;
        }
        return string(bstr);
    }
}
