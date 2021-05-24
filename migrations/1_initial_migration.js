const Migrations = artifacts.require("721");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
