// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AARTArtists is ERC721URIStorage, Ownable {
    //--------------------------------------------------------------------
    // VARIABLES

    uint256 private _tokenIds;
    mapping(uint256 => string) private _tokenURIs;

    struct Profile {
        uint256 id;
        string uri;
    }

    //--------------------------------------------------------------------
    // EVENTS

    event AART__ProfileCreated(uint256 tokenId, address owner, string uri);
    event AART__ProfileUpdated(uint256 tokenId, string newUri);
    event AART__ProfileDeleted(uint256 tokenId);

    //--------------------------------------------------------------------
    // ERRORS

    error AART__AlreadyRegistered();
    error AART__OnlyTokenOwner(uint256 tokenId);

    //--------------------------------------------------------------------
    // CONSTRUCTOR

    constructor() ERC721("AART Artists Profiles", "AAP") {}

    //--------------------------------------------------------------------
    // FUNCTIONS

    function create(string memory uri) external returns (uint256) {
        if (balanceOf(msg.sender) > 0) revert AART__AlreadyRegistered();

        uint256 tokenId = _tokenIds++;
        _safeMint(msg.sender, tokenId);
        _tokenURIs[tokenId] = uri;

        emit AART__ProfileCreated(tokenId, msg.sender, uri);
        return tokenId;
    }

    function update(uint256 tokenId, string memory newUri) external {
        if (msg.sender != ownerOf(tokenId))
            revert AART__OnlyTokenOwner(tokenId);

        _tokenURIs[tokenId] = newUri;
        emit AART__ProfileUpdated(tokenId, newUri);
    }

    function burn(uint256 tokenId) external {
        if (msg.sender != ownerOf(tokenId))
            revert AART__OnlyTokenOwner(tokenId);

        _burn(tokenId);
        delete _tokenURIs[tokenId];

        emit AART__ProfileDeleted(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return _tokenURIs[tokenId];
    }

    function hasProfile(address user) public view returns (bool) {
        return balanceOf(user) > 0;
    }
}