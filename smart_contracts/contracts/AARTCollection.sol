// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IArtists.sol";

contract AARTCollection is ERC721URIStorage, ERC2981, Ownable {
    //--------------------------------------------------------------------
    // VARIABLES

    uint256 private _tokenIds;
    uint256 public paused = 1; // paused = 1, active = 2
    uint256 public mintFee = 10; // Mint fee in MATIC
    address public immutable artistsNftContract;

    mapping(uint256 => string) private _tokenURIs;

    struct ArtRender {
        uint256 id;
        string uri;
    }

    //--------------------------------------------------------------------
    // EVENTS

    event AART__Pause(uint256 state);
    event AART__NewMintFee(uint256 newFee);

    //--------------------------------------------------------------------
    // ERRORS

    error AART__ContractIsPaused();
    error AART__InsufficientAmount();
    error AART__OnlyRegisteredUser();

    //--------------------------------------------------------------------
    // CONSTRUCTOR

    constructor(
        address _artistsNftContract,
        uint256 _mintingFee
    ) ERC721("Artifciel Art Collectible", "AART") {
        artistsNftContract = _artistsNftContract;
        mintFee = _mintingFee;
        _setDefaultRoyalty(msg.sender, 0);
    }

    //--------------------------------------------------------------------
    // FUNCTIONS

    function mintNFT(
        address recipient,
        string memory uri
    ) external payable returns (uint256) {
        return _mintNFT(recipient, uri);
    }

    function mintWithRoyalty(
        address recipient,
        string memory uri,
        address royaltyReceiver,
        uint96 feeNumerator
    ) external payable returns (uint256) {
        uint256 tokenId = _mintNFT(recipient, uri);
        _setTokenRoyalty(tokenId, royaltyReceiver, feeNumerator);
        return tokenId;
    }

    function _mintNFT(
        address recipient,
        string memory uri
    ) internal returns (uint256) {
        if (paused == 1) revert AART__ContractIsPaused();
        if (!IArtists(artistsNftContract).hasProfile(msg.sender))
            revert AART__OnlyRegisteredUser();
        if (msg.value != mintFee) revert AART__InsufficientAmount();

        uint256 tokenId = _tokenIds++;
        _safeMint(recipient, tokenId);
        _tokenURIs[tokenId] = uri;

        return tokenId;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        return _tokenURIs[tokenId];
    }
}
