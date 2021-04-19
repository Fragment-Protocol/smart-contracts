pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract NewToken is ERC20 {
    using SafeMath for uint256;
    address public factory;
    uint8 private counter;
    address private nftAddress;
    uint256 private nftId;

    modifier onlyFactory {
        require(msg.sender == factory, "Only factory can call this function.");
        _;
    }

    constructor(string memory name, string memory symbol, address _factory) public ERC20(name, symbol) {
        //require(_mintAddress != address(0));
        require(_factory != address(0));
        /*require(_decimals>0);
        _setupDecimals(_decimals);*/
        factory = _factory;
        counter = 0;
        /*uint256 initialSupply = _initialSupply * 10 ** uint256(decimals());
        _mint(_mintAddress, initialSupply);
        emit Transfer(address(0x0), _mintAddress, initialSupply);*/
    }

    function init(uint8 _decimals, uint256 _initialSupply, address _mintAddress, address _nftAddr, uint256 _nftId) external onlyFactory {
        require(counter == 0, "This function is disabled");
        require(_mintAddress != address(0));
        require(_decimals>0);
        _setupDecimals(_decimals);
        uint256 initialSupply = _initialSupply * 10 ** uint256(decimals());
        _mint(_mintAddress, initialSupply);
        counter += 1;
        nftAddress = _nftAddr;
        nftId = _nftId;
        emit Transfer(address(0x0), _mintAddress, initialSupply);
    }

    function getNft() public view returns (address, uint256) {
        return (nftAddress, nftId);
    }

    function burn(address from, uint256 amount) external onlyFactory {
        _burn(from, amount);
    }
}