// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { ERC20Burnable } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Fortuna is ERC20, ERC20Burnable, AccessControl, Ownable {
	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

	constructor() ERC20("Fortuna", "FTN") Ownable(msg.sender) {
		_grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
	}


	function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
		_mint(to, amount);
	}
}
