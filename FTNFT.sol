// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/HelloWorld.sol";

contract FestivalTicketNFT is ERC721, Ownable {
    FullFiestaERC20token public token;
    uint256 public nextTokenId;

    constructor(FullFiestaERC20token _token) ERC721("FestivalTicketNFT", "FTNFT") Ownable(msg.sender) {
        token = _token;
        nextTokenId = 1;
    }

    function mintTicket(address to) external onlyOwner {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        nextTokenId = nextTokenId + 1;
    }

    function purchaseTicket(uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or not owner");

        uint256 ticketCost = 1 ether;
        address ticketOwner = ownerOf(tokenId);

        // Check allowance using the ERC-20 token contract
        require(token.allowance(msg.sender, address(this)) >= ticketCost, "Not enough allowance");

        // Transfer tokens from the buyer to the contract
        token.transferFrom(msg.sender, owner(), ticketCost);

        // Transfer the NFT from the current owner to the buyer
        _safeTransfer(ticketOwner, msg.sender, tokenId, "");
    }

    function setTokenContract(FullFiestaERC20token _token) external onlyOwner {
        token = _token;
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
}
