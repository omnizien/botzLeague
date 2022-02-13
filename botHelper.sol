// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./botAvatar.sol";
import "./safemath.sol";

contract botHelper is botAvatar {
    using SafeMath for uint256;


    uint levelUpFee = .001 ether;
    uint coolDownTimer = 5 minutes;
    uint32 leveladd;


    constructor() payable   {
        require (msg.value == levelUpFee) ;

    }

    modifier aboveLevel(uint _level, uint botId) {
        require(bots[botId].level > _level);
        _;
    }

    function _triggerCoolDownFunction(botStruct storage myBot) internal {
        myBot.readyTime = uint32(block.timestamp + coolDownTimer);
    }

    function _isReadyForTimestampBool(botStruct storage myBot) internal view returns (bool) {
        return (myBot.readyTime < block.timestamp);
    }

    function winAndCreate(uint _botId, uint _compound) public {
        require(botToOwner[_botId] == msg.sender);
        botStruct storage myBot = bots[_botId];
        _compound = _compound % botCompoundModulus;
        uint newCompound    = (myBot.compound + _compound) / 2;
        _createBot(strConcat(myBot.name," New Bot"), newCompound   );
    }

    function changeName(uint _botId, string memory _newName) public aboveLevel(1, _botId) {
        bots[_botId].name = _newName;
    }

    function changeBuildCode(uint _botId, uint _newCompound   ) public aboveLevel(9, _botId) {
        bots[_botId].compound = _newCompound   ;
    }

    function getBotsByOwner(address  _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerBotCount[_owner]);

        uint count = 0;
        for(uint i = 0 ; i < bots.length ; i++){
            if(botToOwner[i] == _owner){
                result[count] = i;
                count++;
            }
        }

        return result ;
    }

    function levelUp(uint _botId) public payable {
    require(msg.value == levelUpFee);
    leveladd = bots[_botId].level + 1;
     bots[_botId].level = leveladd  ;
    }


    function increaseLevel(uint _botId) public {
       leveladd = bots[_botId].level + 1;
       bots[_botId].level = leveladd  ;
    }
    //https://ethereum.stackexchange.com/questions/87153/typeerror-send-and-transfer-are-only-available-for-objects-of-type-address

    function withdraw() external onlyOwner {
        //payable owner.transfer(address(this).balance);
        //https://stackoverflow.com/questions/68121086/typeerror-send-and-transfer-are-only-available-for-objects-of-type-address
        payable(owner).transfer(address(this).balance);
    }

    function changeLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // Help functions to concatenate 2 strings
    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        uint i = 0;
        for (i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function strConcat(string memory _a, string memory _b, string  memory _c, string memory _d) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        return strConcat(_a, _b, "", "", "");
    }
}
