// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CoffeeShop {
    enum CoffeeSize {
        SMALL,
        MEDIUM,
        LARGE
    }

    mapping(CoffeeSize => uint256) public prices;
    mapping(CoffeeSize => uint256) public sold;

    constructor(uint256[3] memory _prices) {
        prices[CoffeeSize.SMALL] = _prices[0];
        prices[CoffeeSize.MEDIUM] = _prices[1];
        prices[CoffeeSize.LARGE] = _prices[2];
    }

    function buy(CoffeeSize _size, uint8 _count) public payable {
        require(
            msg.value >= prices[_size] * _count,
            "Not enough Ether provided!"
        );
        sold[_size] += _count;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
