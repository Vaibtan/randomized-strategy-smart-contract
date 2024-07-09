// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 1 ether, "PAY ONLY 1 ether");
        players.push(payable(msg.sender));
    }

    function get_balance() public view returns(uint) {
        require(manager == msg.sender, "ONLY MANAGER HAS ACCESS!");
        return address(this).balance;
     }

     //USE ORACLE
     function randomized_strat() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(
            block.prevrandao, block.timestamp, players.length
        )));
    }

    function pick_winner() public {
        require(manager == msg.sender, "ONLY MANAGER HAS ACCESS!");
        require(players.length >= 3, "PLAYERS SHOULD BE GREATER THAN 3!");
        uint idx = randomized_strat() % players.length ;
        winner = players[idx];
        winner.transfer(get_balance());
        players = new address payable[](0);
    }
}