// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTokenMetadata.sol";
import "./Ownable.sol";

contract Custom721 is NFTokenMetadata, Ownable {
    mapping(uint256 => uint256) public usage;

    mapping(address => bool) public admin;

    uint256 public _tokenIds = 0;

    uint256 public maxUsage;

    uint256 public maxNFT;
    
    uint256 public available;
    
    string public baseUrl;

    constructor(
        uint256 _maxUsage,
        uint256 _maxNFT,
        string memory _nftName,
        string memory _nftSymbol,
        string memory _url
    ) {
        require(_maxNFT > 0 && _maxUsage > 0);
        nftName = _nftName;
        nftSymbol = _nftSymbol;
        admin[msg.sender] = true;
        maxNFT = _maxNFT;
        maxUsage = _maxUsage;
        available = _maxNFT;
        baseUrl = _url;
    }

    function addAdmin(address _address) public onlyAdmin {
        admin[_address] = true;
    }

    function setMaxUsage(uint256 _value) public onlyAdmin {
        maxUsage = _value;
    }
    
    function setMaxNFT(uint256 _value) public onlyAdmin {
        require(_value > 0, "Not a valid _value");
        
        maxNFT += _value;
        available += _value;
    }
    
    function mint(address _to) external onlyAdmin {
        require(_tokenIds < maxNFT, "Max NFT Minted");

        _tokenIds += 1;
        
        available -= 1;

        super._mint(_to, _tokenIds);

        super._setTokenUri(_tokenIds, baseUrl);
    }

    function increment(uint256 _id) public onlyAdmin returns (uint256) {
        require(usage[_id] < maxUsage, "Card Usage Over");
        return usage[_id] += 1;
    }
    
    function decrement(uint256 _id) public onlyAdmin returns (uint256) {
        require(usage[_id] > 0, "Already at Start");
        return usage[_id] -= 1;
    }

    function count(uint256 _id) public view returns (uint256) {
        return usage[_id];
    }

    // Modifier to check that the caller is the owner of
    // the contract.
    modifier onlyAdmin() {
        require(admin[msg.sender] != false, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }
}
