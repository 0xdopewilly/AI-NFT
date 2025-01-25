// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./interfaces/IAARTCollection.sol";
import "./interfaces/IAARTMarket.sol";
import "./utils/AARTErrors.sol";
import "./utils/AARTEvents.sol";
import "./lib/PaymentLib.sol";

/// @title AART NFT marketplace
/// @notice Marketplace that supports direct sales, offers, and auctions for AART NFTs.
contract AARTMarket is
    IAARTMarket,
    AARTErrors,
    AARTEvents,
    Ownable,
    IERC721Receiver
{
    uint256 private constant PRECISION = 1e3;
    uint256 private constant MAX_FEE = 30; // 3% is the maximum trade fee

    Listing[] private _listings;
    Auction[] private _auctions;

    address[] public supportedERC20tokens;
    mapping(address => bool) private _erc20Tokensmapping;
    mapping(uint256 => Offer[]) private _offers;
    mapping(uint256 => mapping(address => uint256)) private auctionBidderAmounts;

    IAARTCollection private immutable nftContract;

    uint256 public fee = 10; // 1%
    address private feeRecipient;

    constructor(address _nftAddress) Ownable() {
        if (_nftAddress == address(0)) revert AARTMarket_AddressZero();
        nftContract = IAARTCollection(_nftAddress);
        feeRecipient = msg.sender;
    }

    // Other marketplace logic remains unchanged...

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}