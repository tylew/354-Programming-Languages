// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721Holder {
    /** These are state variables and must be kept track of carefully to prevent token loss */
    address public nftAddress;
    uint256 public tokenID;
    
    /** The hasToken() modifier will ensure an asset is present in the contract */
    modifier hasToken() {
        require(tokenID != 0, "There is no asset held in the contract");
        _;
    }
    /** The noToken() modifier will ensure that no token is present in the contract before 
     * the function is executed */
    modifier noToken() {
        require(tokenID == 0, "There is already an asset in the contract");
        _;
    }
    
    /** noToken, public, virtual function: overload in child to add further functionality */
    function depositAsset(
        address _NFTAddress, 
        uint256 _TokenID
    ) noToken public virtual
    {
        require( // check token approval for contract address
            ERC721(_NFTAddress).isApprovedForAll(msg.sender, address(this)), 
            "NFT is not approved for transfer"
        ); 
        /** Create temp ERC721 instance to perform a function on the token */
        ERC721(_NFTAddress).safeTransferFrom(msg.sender, address(this), _TokenID);
        /** Transfer successful if got to this point, save data */
        nftAddress = _NFTAddress;
        tokenID = _TokenID;
    }
    
    /** hasToken, internal: only visible to functions within the contract system.
     * Performs no owner-check control. Must be done in child. */
    function withdrawAsset(
        address _receiver
    ) hasToken internal
    {
        ERC721(nftAddress).safeTransferFrom(address(this), _receiver, tokenID);
        nftAddress = address(0); // clear nft data by returning to zero address
        tokenID = 0;
    }
    
    /** hasToken, public, view: This function costs zero to execute, as it does not change 
     * the contract state, simply returns a string from the blockchain */
    function getTokenURI() 
    hasToken public view 
    returns (string memory)
    {
        string memory _return = ERC721(nftAddress).tokenURI(tokenID);
        return _return;
    }
}

contract NFTListing is ERC721Holder {
    
    /** ProjectState enum defines the possible states of the contract */
    enum ProjectState {emptyVault, fullVault, onSale}
    /** projectState variable stores the current state of the contract */
    ProjectState public projectState;

    /** owner variable stores the address of the owner */
    address payable public owner;
    /** buyer variable stores the address of the current buyer (if any) */
    address public buyer;
    /** price variable stores the price of the NFT being sold */
    uint256 public price;

    /** inState modifier checks that the contract is in the specified state */
    modifier inState(ProjectState state) {
        require(projectState == state, "Invalid contract state to run function");
        _;
    }

    /** onlyOwner modifier checks that the caller is the owner */
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    /** enoughFunds modifier checks that the value of the message is greater than 
     * or equal to the price of the NFT */
    modifier enoughFunds() {
        require(msg.value >= price, "Not enough ether sent");
        _;
    }

    /** constructor function is called when the contract is deployed. It sets the 
     * owner to the deployer's address and the projectState to emptyVault */
    constructor() {
        owner = payable(msg.sender);
        projectState = ProjectState.emptyVault;
    }

    /** depositAsset function allows the owner to deposit an ERC721 token into the 
     * contract. It can only be called if the contract is in the emptyVault state and 
     * the caller is the owner */
    function depositAsset(
        address _NFTAddress,
        uint256 _TokenID
    ) public override onlyOwner inState(ProjectState.emptyVault) {
        super.depositAsset(_NFTAddress, _TokenID);
        projectState = ProjectState.fullVault;
    }

    /** initSale function allows the owner to put the NFT up for sale at a specified 
     * price it can only be called if the contract is in the fullVault state and the 
     * caller is the owner */
    function initSale(
        uint256 _price
    ) public onlyOwner inState(ProjectState.fullVault) {
        buyer = address(0);
        price = _price;
        projectState = ProjectState.onSale;
    }

    /** initExclusiveSale function allows the owner to put the NFT up for sale exclusively 
     * to a specific buyer at a specified price it can only be called if the contract is
     * in the fullVault state and the caller is the owner */
    function initExclusiveSale(
        address _buyer,
        uint256 _price
    ) public onlyOwner inState(ProjectState.fullVault)
    {
        buyer = _buyer;
        price = _price;
        projectState = ProjectState.onSale; 
    }

    /** cancelSale function allows the owner to cancel the sale of the NFT it can only be 
     * called if the contract is in the onSale state and the caller is the owner */
    function cancelSale() public onlyOwner inState(ProjectState.onSale) {
        buyer = address(0);
        price = 0;
        /** withdraw the NFT from the contract and set the nftAddress and tokenID variables to 0 */
        super.withdrawAsset(owner);
        projectState = ProjectState.emptyVault;
    }

    /** purchase function allows a buyer to purchase the NFT by sending the required amount of 
     * ether to the contract it can only be called if the contract is in the onSale state 
     * and the value of the message is greater than or equal to the price of the NFT */
    function purchase() public payable enoughFunds inState(ProjectState.onSale) {
        /** if the sale is exclusive and the caller is not the specified buyer, the function 
         * should throw an error */
        require((buyer != address(0) && msg.sender != buyer), "Exclusive sale, transaction sender isnt buyer");    
        /** transfer the ether from the contract to the owner */
        owner.transfer(msg.value);
        /** withdraw the NFT from the contract and transfer it to the caller */
        super.withdrawAsset(msg.sender);
        projectState = ProjectState.emptyVault;
    }

} 
