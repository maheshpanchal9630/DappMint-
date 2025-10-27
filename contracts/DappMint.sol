// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DappMint
 * @dev A simple NFT-like minting DApp to demonstrate core Solidity concepts.
 */
contract DappMint {
    address public owner;
    uint256 public totalMints;

    struct Mint {
        uint256 id;
        address minter;
        string tokenURI;
    }

    mapping(uint256 => Mint) public mints;
    mapping(address => uint256[]) public mintedTokens;

    event Minted(address indexed minter, uint256 indexed tokenId, string tokenURI);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    /**
     * @notice Mint a new token
     * @param _tokenURI The metadata or image link of the token
     */
    function mintToken(string memory _tokenURI) public {
        totalMints += 1;
        mints[totalMints] = Mint(totalMints, msg.sender, _tokenURI);
        mintedTokens[msg.sender].push(totalMints);

        emit Minted(msg.sender, totalMints, _tokenURI);
    }

    /**
     * @notice Get all tokens minted by a specific address
     */
    function getMyMints(address _minter) public view returns (uint256[] memory) {
        return mintedTokens[_minter];
    }

    /**
     * @notice Transfer ownership to a new address
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}
