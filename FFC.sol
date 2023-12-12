// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FullFiestaERC20token is ERC20 {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede llamar a esta funcion");
        _;
    }

    constructor() ERC20("FullFiestaCoin", "FFC") {
        owner = msg.sender;
        _mint(msg.sender, 1000000000000000000000000); 
    }

    function transferTokens(address to, uint256 amount) external {
        _transfer(msg.sender, to, amount);
    }

    function approveSpending(address spender, uint256 amount) external {
        _approve(msg.sender, spender, amount);
    }

    function getBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
    }
}

