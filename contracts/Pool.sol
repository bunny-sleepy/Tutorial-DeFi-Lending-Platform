// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import {IPool} from "./IPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Pool is IPool {
    /** libraries */
    using SafeERC20 for IERC20;

    /** storage */
    // user deposit / borrow data, mapped by asset => user => value
    mapping(address => mapping(address => uint256)) private _userDeposits;
    mapping(address => mapping(address => uint256)) private _userBorrows;
    uint256 public constant _ltv = 5e17;
    uint256 private constant PRICE_PRECISION = 1e18;

    /** constructor */
    constructor() {}

    /// @inheritdoc IPool
    function deposit(address assetAddress, uint256 amount) external {
        require(amount != 0, "Invalid deposit");
        IERC20(assetAddress).safeTransferFrom(msg.sender, address(this), amount);
        _userDeposits[assetAddress][msg.sender] += amount;

        emit Deposit(assetAddress, amount);
    }

    /// @inheritdoc IPool
    function withdraw(address assetAddress, uint256 amount) external returns (uint256) {
        uint256 userBalance = _userDeposits[assetAddress][msg.sender];
        uint256 amountToWithdraw = amount;
        if (amountToWithdraw >= userBalance) {
            amountToWithdraw = userBalance;
        }

        bool valid = verifyUserHealth(assetAddress, msg.sender, amountToWithdraw);
        require((userBalance != 0) && (amountToWithdraw != 0) && valid, "Invalid withdraw");

        IERC20(assetAddress).safeTransfer(msg.sender, amountToWithdraw);
        _userDeposits[assetAddress][msg.sender] -= amountToWithdraw;

        emit Withdraw(assetAddress, amount);
        return amountToWithdraw;
    }

    /** External Functions */
    /// @inheritdoc IPool
    function borrow(address assetAddress, uint256 amount) external {
        bool valid = verifyUserHealth(assetAddress, msg.sender, 0);
        require(valid && (amount != 0), "Invalid borrow");

        IERC20(assetAddress).safeTransfer(msg.sender, amount);
        _userBorrows[assetAddress][msg.sender] += amount;

        emit Borrow(assetAddress, amount);
    }

    /// @inheritdoc IPool
    function repay(address assetAddress, uint256 amount) external returns (uint256) {
        uint256 userDebt = _userBorrows[assetAddress][msg.sender];
        require((amount != 0) && (userDebt != 0), "Invalid repay");
        uint256 amountToRepay = amount;
        if (amountToRepay > userDebt) {
            amountToRepay = userDebt;
        }

        IERC20(assetAddress).safeTransferFrom(msg.sender, address(this), amountToRepay);
        _userBorrows[assetAddress][msg.sender] -= amountToRepay;

        emit Repay(assetAddress, amount);
        return amountToRepay;
    }

    /** Internal Functions */
    // health factor verification
    function verifyUserHealth(address asset, address user, uint256 amountToWithdraw) internal view returns (bool) {
        uint256 userDepositAmount = _userDeposits[asset][user];
        uint256 userBorrowAmount = _userBorrows[asset][user];
        if (userDepositAmount < amountToWithdraw) return false;
        uint256 borrowBalance = preMul(_ltv, userDepositAmount - amountToWithdraw);
        if (userBorrowAmount < borrowBalance) return false;
        return true;
    }

    // math util for multiplication a * b
    function preMul(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a * b + PRICE_PRECISION / 2) / PRICE_PRECISION;
    }

    // math util for devision a / b
    function preDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a * PRICE_PRECISION + PRICE_PRECISION / 2) / b;
    }
}