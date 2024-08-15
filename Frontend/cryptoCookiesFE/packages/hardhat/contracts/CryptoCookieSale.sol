// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Fortuna } from "./Fortuna.sol";

contract CryptoCookieSale {
	uint256 public ratio;
	uint256 public price;
	uint256 public cookiePrice = 10;
	uint256 private ownerPool;
	Fortuna public paymentToken;

	constructor(uint256 _ratio, uint256 _price, Fortuna _paymentToken) {
		ratio = _ratio;
		price = _price;
		paymentToken = _paymentToken;
	}

	mapping(address => uint256) fortunaBalance;
    mapping(address => uint256) lastCookiePurchaseTime;

    modifier oneCookiePerUserPerDay() {
        require(block.timestamp >= lastCookiePurchaseTime[msg.sender] + 1 days, "You can only purchase one cookie per user per day");
        _;
        lastCookiePurchaseTime[msg.sender] = block.timestamp;
    }

	function buyTokens() external payable {
		uint256 amountBought = msg.value + ratio;
		paymentToken.mint(msg.sender, amountBought);
		fortunaBalance[msg.sender] += amountBought;
	}

	function returnTokens(uint256 amount) external {
		require(
			fortunaBalance[msg.sender] >= amount,
			"You dont have enough Fortuna"
		);
		fortunaBalance[msg.sender] -= amount;
		paymentToken.burnFrom(msg.sender, amount);
		(bool success, ) = payable(msg.sender).call{ value: amount / ratio }(
			""
		);
		require(success);
	}


	function getCookie() external oneCookiePerUserPerDay {
		require(
			fortunaBalance[msg.sender] >= cookiePrice,
			"You dont have enough, Fortuna, buy some more"
		);
		fortunaBalance[msg.sender] -= cookiePrice;
		ownerPool += cookiePrice;
        paymentToken.transferFrom(msg.sender, address(this), cookiePrice);
	}
}
