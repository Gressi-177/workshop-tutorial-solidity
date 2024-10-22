import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const TokenModule = buildModule("FloppyModule", (m) => {
  const token = m.contract("Floppy", []);

  return { token };
});

export default TokenModule;
