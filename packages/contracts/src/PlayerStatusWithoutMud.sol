// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlayerStatus {

    struct Player {
        uint32 life;
        uint32 mana;
        uint32 level;
        bytes32[] items;
    }

    mapping(bytes32 => Player) private players;

    // Setter and getters

    function setPlayerStatus(bytes32 playerId, uint32 life, uint32 mana, uint32 level, bytes32[] memory items) public {
        players[playerId] = Player(life, mana, level, items);
    }

    function getPlayerStatus(bytes32 playerId) public view returns (uint32, uint32, uint32, bytes32[] memory) {
        Player storage player = players[playerId];
        return (player.life, player.mana, player.level, player.items);
    }
}