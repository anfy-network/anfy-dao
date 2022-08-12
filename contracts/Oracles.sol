// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.7.5;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "./presets/OwnablePausableUpgradeable.sol";
import "./interfaces/IRewardEthToken.sol";
import "./interfaces/IPool.sol";
import "./interfaces/IOracles.sol";
import "./interfaces/IMerkleDistributor.sol";
import "./interfaces/IPoolValidators.sol";

/**
 * @title Oracles
 *
 * @dev Oracles contract stores accounts responsible for submitting or update values based on the off-chain data.
 * The threshold of inputs from different oracles is required to submit the data.
 */

contract Oracles is IOracles, OwnablePausableUpgradeable {
    using SafeMathUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;

    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");

    // @dev Rewards nonce is used to protect from submitting the same rewards vote several times.
    CountersUpgradeable.Counter private rewardsNonce;

    // @dev Validators nonce is used to protect from submitting the same validator vote several times.
    CountersUpgradeable.Counter private validatorsNonce;

    // @dev Address of the RewardEthToken contract.
    IRewardEthToken private rewardEthToken;

    // @dev Address of the Pool contract.
    IPool private pool;

    // @dev Address of the PoolValidators contract.
    IPoolValidators private poolValidators;

    // @dev Address of the MerkleDistributor contract.
    IMerkleDistributor private merkleDistributor;

    /**
    * @dev Modifier for checking whether the caller is an oracle.
    */
    modifier onlyOracle() {
        require(hasRole(ORACLE_ROLE, msg.sender), "Oracles: access denied");
        _;
    }

    /**
     * @dev See {IOracles-currentRewardsNonce}.
     */
    function currentRewardsNonce() external override view returns (uint256) {
        return rewardsNonce.current();
    }

    /**
     * @dev See {IOracles-currentValidatorsNonce}.
     */
    function currentValidatorsNonce() external override view returns (uint256) {
        return validatorsNonce.current();
    }

    /**
     * @dev See {IOracles-isOracle}.
     */
    function isOracle(address account) external override view returns (bool) {
        return hasRole(ORACLE_ROLE, account);
    }

    /**
     * @dev See {IOracles-addOracle}.
     */
    function addOracle(address account) external override {
        require(account != address(0), "Oracles: invalid oracle address");
        grantRole(ORACLE_ROLE, account);
        emit OracleAdded(account);
    }

    /**
     * @dev See {IOracles-removeOracle}.
     */
    function removeOracle(address account) external override {
        revokeRole(ORACLE_ROLE, account);
        emit OracleRemoved(account);
    }

    /**
     * @dev See {IOracles-isMerkleRootVoting}.
     */
    function isMerkleRootVoting() public override view returns (bool) {
        uint256 lastRewardBlockNumber = rewardEthToken.lastUpdateBlockNumber();
        return merkleDistributor.lastUpdateBlockNumber() < lastRewardBlockNumber && lastRewardBlockNumber != block.number;
    }

    /**
    * @dev Function for checking whether number of signatures is enough to update the value.
    * @param signaturesCount - number of signatures.
    */
    function isEnoughSignatures(uint256 signaturesCount) internal view returns (bool) {
        uint256 totalOracles = getRoleMemberCount(ORACLE_ROLE);
        return totalOracles >= signaturesCount && signaturesCount.mul(3) > totalOracles.mul(2);
    }