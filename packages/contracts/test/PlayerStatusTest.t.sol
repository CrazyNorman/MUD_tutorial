// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import { MudTest } from "@latticexyz/store/src/MudTest.sol";
import { getKeysWithValue } from "@latticexyz/world/src/modules/keyswithvalue/getKeysWithValue.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { PlayerStatus} from "../src/codegen/Tables.sol";

contract PlayerStatusTest is MudTest {
  IWorld public world;

  bytes32 constant TEST_USER = bytes32("user1");
  uint32 constant INIT_LIFE = 100;
  uint32 constant INIT_MANA = 100;
  bytes32 constant SWORD_ITEM = bytes32("sword");
  bytes32 constant HEALTH_POTION_ITEM = bytes32("Health Potion");
  bytes32 constant MANA_POTION_ITEM = bytes32("Mana Potion");

  function setUp() public override {
    super.setUp();
    world = IWorld(worldAddress);

    // Create a new user.
    world.createUser(TEST_USER);
  }

  function testWorldExists() public {
    uint256 codeSize;
    address addr = worldAddress;
    assembly {
      codeSize := extcodesize(addr)
    }
    assertTrue(codeSize > 0);
  }

  function testPlayerInit() public {
    // Expect the counter to be 1 because it was incremented in the PostDeploy script.
    uint32 life = PlayerStatus.getLife(world, TEST_USER);
    assertEq(life, INIT_LIFE);
  }

  function testUserMana() public {
    uint32 manaBefore = PlayerStatus.getMana(world, TEST_USER);
    uint32 manaUsage = 25;
    assertEq(manaBefore, INIT_MANA);
    world.useMana(TEST_USER, manaUsage);
    uint32 manaAfter = PlayerStatus.getMana(world, TEST_USER);
    assertEq(manaAfter, INIT_MANA - manaUsage);
  }

  function testConsumeManaAndLife() public {
    uint32 manaBefore = PlayerStatus.getMana(world, TEST_USER);
    uint32 lifeBefore = PlayerStatus.getLife(world, TEST_USER);
    uint32 manaUsage = 35;
    uint32 lifeUsage = 5;
    assertEq(manaBefore, INIT_MANA);
    assertEq(lifeBefore, INIT_LIFE);
    world.consumeManaAndLife(TEST_USER, manaUsage, lifeUsage);
    uint32 manaAfter = PlayerStatus.getMana(world, TEST_USER);
    uint32 lifeAfter = PlayerStatus.getLife(world, TEST_USER);
    assertEq(manaAfter, INIT_MANA - manaUsage);
    assertEq(lifeAfter, INIT_LIFE - lifeUsage);
  }

  function testItems() public {
    vm.expectRevert("Index out of range");
    world.getItem(TEST_USER, 1);

    world.addItem(TEST_USER, HEALTH_POTION_ITEM);
   
    assertEq(world.getItem(TEST_USER, 0), SWORD_ITEM);
    assertEq(world.getItem(TEST_USER, 1), HEALTH_POTION_ITEM);

    assertEq(world.hasItem(TEST_USER, SWORD_ITEM), true);
    assertEq(world.hasItem(TEST_USER, HEALTH_POTION_ITEM), true);
    assertEq(world.hasItem(TEST_USER, MANA_POTION_ITEM), false);

    bytes32[] memory items = new bytes32[](3);
    items[0] = HEALTH_POTION_ITEM;
    items[1] = MANA_POTION_ITEM;
    items[2] = SWORD_ITEM;
    world.setItems(TEST_USER, items);

    assertEq(world.getItem(TEST_USER, 2), SWORD_ITEM);

    assertEq(world.hasItem(TEST_USER, SWORD_ITEM), true);
    assertEq(world.hasItem(TEST_USER, HEALTH_POTION_ITEM), true);
    assertEq(world.hasItem(TEST_USER, MANA_POTION_ITEM), true);
  }
}
