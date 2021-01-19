pragma solidity ^0.6.6;

import "./ZombieBattle.sol";
import "./ERC721.sol";

contract ZombieOwnership is ZombieBattle, ERC721 {
    mapping (uint => address) zombieApprovals;
    
    function balanceOf(address _owner) public virtual override view returns(uint) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint _tokenId) public virtual override view returns(address) {
        return zombieToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public virtual override {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public virtual override onlyOwnerOf(_tokenId) {
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public virtual override {
        require(zombieApprovals[_tokenId] == msg.sender);
        _transfer(zombieToOwner[_tokenId], msg.sender, _tokenId);
    }
}