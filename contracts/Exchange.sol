pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract ExchangeFromEthereum is IERC721Receiver, ReentrancyGuard {
    //NftTokenInfo[] allNFT;

    struct NftTokenInfo {
        address tokenAddress;
        uint256 id;
        bool sent;
    }

    mapping(address => NftTokenInfo[]) private deposits;
    mapping(address => NftTokenInfo[]) public activeDeposits;

    event DepositNFT(address owner, address tokenAddress, uint256 tokenId, string name, string symbol, uint8 decimals, uint256 amount);

    function depositNft(address nftAddress, uint256 nftId, uint256 amount, string memory name, string memory symbol, uint8 decimals) external nonReentrant{
        require(nftAddress != address(0), "Wrong NFT contract address");
        require(amount > 0, "Amount must be more then zero");
        require(decimals > 0, "Decimals must be more then zero");
        NftTokenInfo memory nft = NftTokenInfo(nftAddress, nftId, false);
        IERC721(nftAddress).safeTransferFrom(
            msg.sender,
            address(this),
            nftId
        );
        deposits[msg.sender].push(nft);
        activeDeposits[msg.sender].push(nft);
        emit DepositNFT(msg.sender, nftAddress, nftId, name, symbol, decimals, amount);
    }

    function withdrawNft(uint256 index) external nonReentrant {
        require(index >=0 && deposits[msg.sender].length >= index, "Wrong index");
        require(!deposits[msg.sender][index].sent, "Deposit has already withdrawn");
        IERC721(deposits[msg.sender][index].tokenAddress).safeTransferFrom(
            address(this),
            msg.sender,
            deposits[msg.sender][index].id
        );
        deposits[msg.sender][index].sent = true;
        uint256 actLeng = activeDeposits[msg.sender].length;
        if (index < actLeng  - 1)
            activeDeposits[msg.sender][index] = activeDeposits[msg.sender][actLeng - 1];
        activeDeposits[msg.sender].pop();
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    )
    external 
    override 
    returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}