const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RpgBattleSystem", function () {
  let RpgBattleSystem;
  let rpgBattleSystem;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    RpgBattleSystem = await ethers.getContractFactory("RpgBattleSystem");
    [owner, addr1, addr2] = await hre.ethers.getSigners();
    rpgBattleSystem = await RpgBattleSystem.deploy();
    await rpgBattleSystem.deployed();
  });

  it("can create characters", async function () {

    const createCharacterTx1 = await rpgBattleSystem.connect(addr1).createRandomCharacter("Bob");
    await createCharacterTx1.wait();

    const createCharacterTx2 = await rpgBattleSystem.connect(addr2).createRandomCharacter("Alice");
    await createCharacterTx2.wait();

    expect(await rpgBattleSystem.connect(addr1).getCharacterStats(0)).to.have.lengthOf(2);
    expect(await rpgBattleSystem.connect(addr2).getCharacterStats(1)).to.have.lengthOf(2);

  });

  it("players can attack each other", async function () {

    const createCharacterTx1 = await rpgBattleSystem.connect(addr1).createRandomCharacter("Bob");
    await createCharacterTx1.wait();

    const createCharacterTx2 = await rpgBattleSystem.connect(addr2).createRandomCharacter("Alice");
    await createCharacterTx2.wait();

    const player1AttacksPlayer2Tx = await rpgBattleSystem.connect(addr1).attack(0, 1);
    const battle1Result = await player1AttacksPlayer2Tx.wait();
   
    
    const player2AttacksPlayer1Tx = await rpgBattleSystem.connect(addr2).attack(1, 0);
    const battle2Result = await player2AttacksPlayer1Tx.wait();

    // console.log("TKTK2", battle1Result.events);

    expect(battle1Result.events).to.have.lengthOf.above(0);
    expect(battle1Result.events[0].event).to.equal("NewBattleEvent")
    expect(battle1Result.events[0].args).to.contain.all.keys('characterId', "targetId", "battleResult");


    expect(battle2Result.events).to.have.lengthOf.above(0);
    expect(battle2Result.events[0].event).to.equal("NewBattleEvent")
    expect(battle2Result.events[0].args).to.contain.all.keys('characterId', "targetId", "battleResult");

  

  });

  it("players can not attack others too frequently", async function () {

    const createCharacterTx1 = await rpgBattleSystem.connect(addr1).createRandomCharacter("Bob");
    await createCharacterTx1.wait();

    const createCharacterTx2 = await rpgBattleSystem.connect(addr2).createRandomCharacter("Alice");
    await createCharacterTx2.wait();

    const player1AttacksPlayer2Tx = await rpgBattleSystem.connect(addr1).attack(0, 1);
    await player1AttacksPlayer2Tx.wait();

    await expect(
      rpgBattleSystem.connect(addr1).attack(0, 1)
    ).to.be.revertedWith("You can not attack too frequently, have a rest for a while..");


    const player2AttacksPlayer1Tx = await rpgBattleSystem.connect(addr2).attack(1, 0);
    await player2AttacksPlayer1Tx.wait();

    await expect(
      rpgBattleSystem.connect(addr2).attack(1, 0)
    ).to.be.revertedWith("You can not attack too frequently, have a rest for a while..");

    // for (let i = 0; i < 5; i++) {
    //   console.log(`\n\nBattle [${i}]`);
    //   const attackTx = await rpgBattleSystem.connect(addr2).attack(1, 0);
    //   console.log("Attack Result: ", attackTx);
    //   await network.provider.send("evm_increaseTime", [3600])
    //   await network.provider.send("evm_mine")
    // }

  });

  it("players can attack again after cooldown", async function () {

    const createCharacterTx1 = await rpgBattleSystem.connect(addr1).createRandomCharacter("tk");
    await createCharacterTx1.wait();

    const createCharacterTx2 = await rpgBattleSystem.connect(addr2).createRandomCharacter("cbk");
    await createCharacterTx2.wait();

    const player1AttacksPlayer2Tx = await rpgBattleSystem.connect(addr1).attack(0, 1);
    await player1AttacksPlayer2Tx.wait();

    await expect(
      rpgBattleSystem.connect(addr1).attack(0, 1)
    ).to.be.revertedWith("You can not attack too frequently, have a rest for a while..");

    // todo kontratin degiskenini oku cooldown icin onu buraya koyalim
    await network.provider.send("evm_increaseTime", [50])
    await network.provider.send("evm_mine")

    const player2AttacksPlayer1Tx = await rpgBattleSystem.connect(addr2).attack(1, 0);
    await player2AttacksPlayer1Tx.wait();

    await expect(
      rpgBattleSystem.connect(addr2).attack(1, 0)
    ).to.be.revertedWith("You can not attack too frequently, have a rest for a while..");

  });

});
