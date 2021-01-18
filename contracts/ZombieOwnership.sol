pragma solidity ^0.4.19;

import "./ZombieBattle.sol";
import "./ERC721.sol";

contract ZombieOwnership is ZombieBattle, ERC721 {
    mapping (uint => address) zombieApprovals;
    
    function balanceOf(address _owner) public view returns(uint) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint _tokenId) public view returns(address) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;

        Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(zombieApprovals[_tokenId] == msg.sender);
        _transfer(zombieToOwner[_tokenId], msg.sender, _tokenId);
    }
}