// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0
import "./Ownable.sol";
import "./safemath.sol";

contract botAvatar is Ownable {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    uint botCompound = 16;
    uint botCompoundModulus = 10 ** 16;

    struct botStruct {
        string name;
        uint  compound;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    botStruct[] public bots;

    event botCreated(string name, uint skill);

    mapping (uint => address) public botToOwner;
    mapping (address => uint)  ownerBotCount;

    function createBot(string memory _name, uint _compound)   internal {
       //original line:
       //uint id = bots.push(bot(_name, _ compound, 1, uint32(block.timestamp), 0, 0)) -1;
         bots.push(botStruct(_name, _compound, 1, uint32(block.timestamp), 0, 0));
         uint id = bots.length -1;
         botToOwner[id] = msg.sender;
          ownerBotCount[msg.sender]++;
         emit botCreated(_name, _compound);
    }

    function generateCompound(string  memory _name) private view returns(uint){
        uint  compound = uint(keccak256(abi.encodePacked (_name)));
        return  compound % botCompoundModulus;
    }

    function generateBot(string memory _name) public {
        require( ownerBotCount[msg.sender] == 0);
        uint  compound = generateCompound(_name);
        _createBot(_name, compound);
    }
     

    function getOwnerBotCount() public view returns(uint) {
        return  ownerBotCount[msg.sender];
    }

    function totalbots() public view returns(uint) {
        return bots.length;
    }

}
