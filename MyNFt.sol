//SPDX-License-Identifier:MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.3.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.3.1/token/ERC721/extensions/ERC721Enumerable.sol"; 
import "@openzeppelin/contracts@4.3.1/access/Ownable.sol";
import "@openzeppelin/contracts@4.3.1/utils/Counters.sol";

contract project is ERC721,ERC721Enumerable,Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public mintRate =0.01 ether;
    uint public MAX_SUPPLY = 10000;

    constructor() ERC721("MyNFT","MNFT") {} 

    function _baseURI() internal pure override returns (string memory) {
        return "https://api.mynft.com/tokens/";
    }

    function safeMint(address to) public payable {
        require(totalSupply() < MAX_SUPPLY,"Can't mint more.");
        require(msg.value >= mintRate,"Not enough ether sent.");
        _tokenIdCounter.increment();
        _safeMint(to,_tokenIdCounter.current());
    }
//The following functions are overrides required ny solidity.

function _beforeTokenTransfer(address from ,address to ,uint256 tokenId)
internal 
override (ERC721,ERC721Enumerable)
{
    super._beforeTokenTransfer(from, to, tokenId);
}

    function supportsInterface( bytes4 interfaceId)
public 
view 
override (ERC721,ERC721Enumerable)
returns(bool)
{
    return super.supportsInterface(interfaceId);
}

function withdraw() public onlyOwner {
require(address(this).balance > 0,"Balance is 0");
payable(owner()).transfer(address(this).balance);
}
}