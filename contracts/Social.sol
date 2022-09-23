// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./libraries/MessageArray.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Social is Ownable {
    using MessageArrayLib for MessageArrayLib.Messages;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // アカウント
    struct Account {
        // アカウントID
        address payable id;
        // 名前
        string name;
        // アバター
        string avatar;
        // 経歴
        string history;
        // いいね
        EnumerableSet.Bytes32Set favorites;
    }

    // ユーザー
    mapping(address => Account) accounts;
    // 投稿文
    MessageArrayLib.Messages messages;
    // 投稿文へのいいね数
    mapping(bytes32 => Counters.Counter) favorites;

    constructor() {}

    function postMessage(string memory _text) public {
        uint publishedAt = block.timestamp;
        bytes32 id = keccak256(abi.encodePacked(msg.sender, publishedAt));
        MessageArrayLib.Message memory message = MessageArrayLib.Message({
            id: id,
            owner: payable(msg.sender),
            text: _text,
            publishedAt: publishedAt
        });

        messages.pushMessage(message);
    }

    function getAllMessages()
        public
        view
        returns (MessageArrayLib.Message[] memory)
    {
        return messages.getAllMessages();
    }
}
