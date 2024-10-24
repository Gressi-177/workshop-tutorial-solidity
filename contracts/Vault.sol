// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";

contract Vault is Ownable, AccessControlEnumerable {
    using SafeERC20 for IERC20;

    IERC20 private token;
    uint256 public maxWithdrawAmount;
    bool public withdrawEnable;
    bytes32 public constant WITHDRAWER_ROLE = keccak256("MY_ROLE");

    constructor() Ownable(msg.sender) AccessControlEnumerable() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setWithdrawEnable(bool _isEnable) public onlyOwner {
        withdrawEnable = _isEnable;
    }

    function setMaxWithdrawAmount(uint256 _maxWithdrawAmount) public onlyOwner {
        maxWithdrawAmount = _maxWithdrawAmount;
    }

    function setToken(IERC20 _token) public onlyOwner {
        token = _token;
    }

    function withdraw(uint256 _amount, address _to) external {
        require(withdrawEnable, "withdraw is disabled");
        require(_amount <= maxWithdrawAmount, "Caller is not a minter");
        token.safeTransfer(_to, _amount);
    }

    function deposit(uint256 _amount) external {
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance");
        SafeERC20.safeTransferFrom(token, msg.sender, address(this), _amount);
    }

    modifier onlyWithdrawer() {
        require(
            owner() == msg.sender || hasRole(WITHDRAWER_ROLE, msg.sender),
            "Caller is not a withdrawer"
        );
        _;
    }
}
