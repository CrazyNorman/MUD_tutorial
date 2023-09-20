pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { PlayerStatus, PlayerStatusData } from "../codegen/Tables.sol";

contract PlayerSystem is System {
    function createUser(bytes32 userId) public {
        bytes32[] memory items = new bytes32[](1);
        items[0] = bytes32("sword");

        PlayerStatus.set(userId, 100, 100, 1, items);
    }

    function useMana(bytes32 userId, uint32 usage) public {
        // 单个字段查询
        uint32 mana = PlayerStatus.getMana(userId);
        require(mana >= usage, "Not enough mana");
        // 单个字段赋值
        PlayerStatus.setMana(userId, mana - usage);
    }

    function consumeManaAndLife(bytes32 userId, uint32 manaUsage, uint32 lifeUsage) public {
        // 整条记录查询
        PlayerStatusData memory player = PlayerStatus.get(userId);
        require(player.mana >= manaUsage, "Not enough mana");
        require(player.life >= lifeUsage, "Not enough life");
        // 整条记录替换
        PlayerStatus.set(userId, player.life - lifeUsage, player.mana - manaUsage, player.level, player.items);
    }

    function addItem(bytes32 userId, bytes32 itemName) public {
        // 数组append操作
        PlayerStatus.pushItems(userId, itemName);
    }

    function setItems(bytes32 userId, bytes32[] memory items) public {
        // 数组整组替换
        PlayerStatus.setItems(userId, items);
    }

    function getItem(bytes32 userId, uint256 index) public view returns (bytes32) {
        // 数组型字段长度查询
        uint itemLength = PlayerStatus.lengthItems(userId);
        require(itemLength > index, "Index out of range");
        // 数组指定索引的值查询
        return PlayerStatus.getItemItems(userId, index);
    }

    function hasItem(bytes32 userId, bytes32 itemName) public view returns (bool) {
        bytes32[] memory items = PlayerStatus.getItems(userId);
        for (uint256 i = 0; i < items.length; i++) {
            if (items[i] == itemName) {
                return true;
            }
        }
        return false;
    }

}