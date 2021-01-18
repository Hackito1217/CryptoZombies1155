pragma solidity ^0.4.19;

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

    function _createZombie(string _name, uint _dna) internal {
        uint zombieId = zombies.push(Zombie(_name, _dna, 1, 0, 0, 0)) - 1;
        // uint zombieId = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        
        zombieToOwner[zombieId] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        
        NewZombie(zombieId, _name, _dna);
    }

    function _generateRandomDna(string _str) private view returns(uint) {
        return uint(keccak256(_str)) % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        _createZombie(_name, _generateRandomDna(_name));
    }
}
