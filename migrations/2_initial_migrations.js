const Zombie = artifacts.require("ZombieOwnership");

module.exports = function (deployer) {
  deployer.deploy(Zombie);
};
