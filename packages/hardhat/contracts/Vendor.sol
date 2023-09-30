pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
	event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
	event SellTokens(
		address seller,
		uint256 amountOfTokens,
		uint256 amountOfETH
	);

	YourToken public yourToken;

	uint256 public constant tokensPerEth = 100;

	constructor(address tokenAddress) {
		yourToken = YourToken(tokenAddress);
	}

	// ToDo: create a payable buyTokens() function:

	function buyTokens() public payable {
		uint256 amountofToken = (msg.value * 1 ether) / 0.01 ether;
		require(amountofToken > 0, "Not enough");
		yourToken.transfer(msg.sender, amountofToken);
		emit BuyTokens(msg.sender, msg.value, amountofToken);
	}

	// ToDo: create a withdraw() function that lets the owner withdraw ETH
	function withdraw() public payable onlyOwner {
		uint256 balance = address(this).balance;

		(bool success, ) = msg.sender.call{ value: balance }("");
		require(success);
	}

	// ToDo: create a sellTokens(uint256 _amount) function:

	function sellTokens(uint256 _amount) public payable {
		yourToken.transferFrom(msg.sender, address(this), _amount);
		withdraw();

		emit SellTokens(msg.sender, _amount, msg.value);
	}
}
