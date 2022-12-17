// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract ERC721Holder is IERC721Receiver {

    address public nftAddress;
    uint256 public tokenID;

    function onERC721Received( 
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data 
    ) pure public override returns (bytes4) 
    {
        return this.onERC721Received.selector;
    }

    function depositAsset(
        address _NFTAddress, 
        uint256 _TokenID
    ) private 
    {
        require(ERC721(_NFTAddress).isApprovedForAll(msg.sender, address(this)), "NFT is not approved for transfer");
        nftAddress = _NFTAddress;
        tokenID = _TokenID;
        ERC721(nftAddress).safeTransferFrom(msg.sender, address(this), tokenID);
    }

    function withdrawAsset(
        address _receiver
    ) private
    {
        require(tokenID != 0, "No asset held by contract");
        ERC721(nftAddress).safeTransferFrom(address(this), _receiver, tokenID);
        nftAddress = address(0);
        tokenID = 0;
    }
}


contract Escrow is ERC721Holder {
    
    enum ProjectState {newEscrow, nftDeposited, cancelNFT, ethDeposited, canceledBeforeDelivery, deliveryInitiated, delivered}
    
    address payable public sellerAddress;
    address payable public buyerAddress;

    bool buyerCancel = false;
    bool sellerCancel = false;
    ProjectState public projectState;

    /// Function cannot be called at this time.
    error FunctionInvalidAtThisStage();

    modifier inState(ProjectState state) {
        if (projectState != projectState)
            revert FunctionInvalidAtThisStage();
        _;
    }

    modifier onlySeller() {
        require(msg.sender == sellerAddress, "You are not the seller!");
        _;
    }

    constructor()
    {
        sellerAddress = payable(msg.sender);
        projectState = ProjectState.newEscrow;
    }
} 
