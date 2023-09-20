import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  excludeSystems: [], // list of system names to exclude
  // worldContractName: "CustomWorld", // default is "World"
  // namespace: "mud", // default is "ROOT"
  systems: {
    IncrementSystem: {
      name: "Increment",
      openAccess: true,
    },
    PlayerSystem: {
      name: "Player",
      openAccess: false,
      accessList: [], // list of allowed access address to this system
    },
  },
  tables: {
    Counter: {
      keySchema: {},
      schema: "uint32",
    },
    PlayerStatus: {
      keySchema: {
        playerId: "bytes32",
      },
      schema: {
        life: "uint32",
        mana: "uint32",
        level: "uint32",
        items: "bytes32[]", // Store supports dynamic arrays
      },
    },
  },
});
