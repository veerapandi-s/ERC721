// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFTokenMetadata.sol";
import "./Ownable.sol";

contract newNFT is NFTokenMetadata, Ownable {
    mapping(uint256 => uint256) public points;

    mapping(address => bool) public admin;

    uint256 public _tokenIds = 0;

    uint256 public maxUsage;

    uint256 public maxNFT;

    constructor(
        uint256 _maxUsage,
        uint256 _maxNFT,
        string memory _nftName,
        string memory _nftSymbol
    ) {
        require(_maxNFT > 0 && _maxUsage > 0);
        nftName = _nftName;
        nftSymbol = _nftSymbol;
        admin[msg.sender] = true;
        maxNFT = _maxNFT;
        maxUsage = _maxUsage;
    }

    function addOwner(address _address) public onlyAdmin {
        admin[_address] = true;
    }

    function setMaxUsage(uint256 _value) public onlyAdmin {
        maxUsage = _value;
    }

    function mint(address _to, string calldata _uri) external onlyOwner {
        require(_tokenIds < maxUsage, "Max NFT Minted");

        _tokenIds += 1;

        super._mint(_to, _tokenIds);

        super._setTokenUri(_tokenIds, _uri);
    }

    function increment(uint256 _id) public onlyAdmin returns (uint256) {
        require(points[_id] < maxUsage, "Card Usage Over");
        return points[_id] += 1;
    }

    function count(uint256 _id) public view returns (uint256) {
        return points[_id];
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