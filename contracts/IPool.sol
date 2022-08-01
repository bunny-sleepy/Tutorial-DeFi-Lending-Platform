// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

interface IPool {
    event Deposit(address assetAddress, uint256 amount);
    event Withdraw(address assetAddress, uint256 amount);
    event Borrow(address assetAddress, uint256 amount);
    event Repay(address assetAddress, uint256 amount);

    /**
     * @dev Deposit an `amount` of underlying asset into the reserve
     * @param assetAddress The address of the underlying asset to deposit
     * @param amount The amount to deposit
     **/
    function deposit(address assetAddress, uint256 amount) external;

    /**
     * @dev Withdraws an `amount` of underlying asset from the reserve
     * @param assetAddress The address of the underlying asset to withdraw
     * @param amount The underlying amount to be withdrawn
     *   - Send the value type(uint256).max in order to withdraw the whole balance
     * @return The final amount withdrawn
     **/
    function withdraw(address assetAddress, uint256 amount) external returns (uint256);

    /**
     * @dev Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
     * already supplied enough collateral
     * @param assetAddress The address of the underlying asset to borrow
     * @param amount The amount to be borrowed
     **/
    function borrow(address assetAddress, uint256 amount) external;

    /**
     * @notice Repays a borrowed `amount` on a specific underlying asset
     * @param assetAddress The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `assetAddress`
     * @return The final amount repaid
     **/
    function repay(address assetAddress, uint256 amount) external returns (uint256);
}