pragma solidity ^0.6.6;

import "./Ownable.sol";
import "./SafeMath.sol";

contract ZombieFactory is Ownable {
    using SafeMath for uint256;
    using SafeMath16 for uint16;
    using SafeMath32 for uint32;

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, 0, 0, 0));
        uint zombieId = zombies.length - 1;
        
        zombieToOwner[zombieId] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        
        emit NewZombie(zombieId, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns(uint) {
        return uint(keccak256(bytes(_str))) % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        _createZombie(_name, _generateRandomDna(_name));
    }
}
