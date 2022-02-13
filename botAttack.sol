// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./botHelper.sol";

contract botAttack is botHelper {

    uint randNonce;
    uint attackingProbability = 70;

    function randomMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked (block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _botId, uint _targetId) external {
        require(msg.sender == botToOwner[_botId] && _botId != _targetId && _isReadyForTimestampBool(bots[_botId]));     
        botStruct storage mybot = bots[_botId];
        botStruct storage frienemybot = bots[_targetId];  
        uint rand;
        rand = randomMod(100);

        // win
        if (rand < attackingProbability) {
             
            mybot.level++;
            frienemybot.lossCount++;
            mybot.winCount++;
            winAndCreate(_botId, frienemybot.dna);

        // loss
        } else {
            mybot.lossCount++;
            frienemybot.winCount++;
        }

        _triggerCoolDownFunction(mybot);
    }
}
