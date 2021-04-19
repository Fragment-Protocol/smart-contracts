const Migrations = artifacts.require("Factory");

module.exports = function(deployer) {
  deployer.deploy(Migrations, "0x6619D419A27bb005a0a51DA2610d036133E72a72");
};
