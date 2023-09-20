// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

interface IPlayerSystem {
  function createUser(bytes32 userId) external;

  function useMana(bytes32 userId, uint32 usage) external;

  function consumeManaAndLife(bytes32 userId, uint32 manaUsage, uint32 lifeUsage) external;

  function addItem(bytes32 userId, bytes32 itemName) external;

  function setItems(bytes32 userId, bytes32[] memory items) external;

  function getItem(bytes32 userId, uint256 index) external view returns (bytes32);

  function hasItem(bytes32 userId, bytes32 itemName) external view returns (bool);
}
