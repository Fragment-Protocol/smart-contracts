const MyERC721 = artifacts.require("MyNftToken");

module.exports = async function(deployer) {
  await deployer.deploy(MyERC721, "RitaNFT", "RITA")
  const erc721 = await MyERC721.deployed()
  await erc721.mintUniqueTokenTo("0x6619D419A27bb005a0a51DA2610d036133E72a72",1,"simple desc")
};