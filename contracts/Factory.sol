pragma solidity ^0.6.0;

import "./Token.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Factory is ReentrancyGuard{
    address operator;

    //mapping(address => uint256) private returned;
    //mapping(address => bool) public ableToWithdraw;

    modifier onlyOperator {
        require(msg.sender == operator, "Only operator can call this function.");
        _;
    }

    constructor (address _operator) public {
        operator = _operator;
    }

    event ChangeOperator (address oldOperator, address newOperator);
    event TokenCreated(address tokenAddress);
    event IsReadyToWithdraw(address nftAddress, uint256 nftId);

    function deployNewToken(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address issuer, address nftAddress, uint256 nftId) 
    external onlyOperator
    returns (address) 
    {
        NewToken token = new NewToken(name, symbol, address(this));
        token.init(decimals, totalSupply, issuer, nftAddress, nftId);
        //returned[address(token)] = 0;
        //ableToWithdraw[address(token)] = false;
        emit TokenCreated(address(token));
    }

    function changeOperator(address newOperator) external onlyOperator {
        require(newOperator != address(0), "Operator can not be the zero address");
        address oldOperator = operator;
        operator = newOperator;
        emit ChangeOperator(oldOperator, operator);
    }

    function returnTokens(address tokenAddress, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount should be more then zero");
        require(IERC20(tokenAddress).balanceOf(msg.sender) >= amount, "Not enough tokens");
        IERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        //returned[tokenAddress] += amount;
        uint256 totalSupply = IERC20(tokenAddress).totalSupply();
        if(IERC20(tokenAddress).balanceOf(address(this)) == totalSupply){
            NewToken(tokenAddress).burn(address(this), totalSupply);
            address nftTokenAddress;
            uint256 nftTokenId;
            (nftTokenAddress,nftTokenId) = NewToken(tokenAddress).getNft();
            emit IsReadyToWithdraw(nftTokenAddress, nftTokenId);
        }
    }
}