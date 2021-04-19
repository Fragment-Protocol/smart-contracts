const Migrations = artifacts.require("ExchangeFromEthereum");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};