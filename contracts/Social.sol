// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./libraries/MessageArray.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Social is Ownable {
    using MessageArrayLib for MessageArrayLib.Messages;
    using EnumerableSet for EnumerableSet.Bytes32Set;
    using Counters for Counters.Counter;

    // アカウント
    struct Account {
        // アカウントID
        address payable id;
        // 名前
        string name;
    }

    // ユーザー
    mapping(address => Account) accounts;

    // ユーザーIDから「いいね」一覧
    mapping(address => EnumerableSet.Bytes32Set) addressTofavorites;

    // 投稿文
    MessageArrayLib.Messages messages;

    // 投稿文へのいいね数
    mapping(bytes32 => Counters.Counter) favorites;

    // 入力最大値
    uint public maxLength = 1000;

    // 初期化
    constructor() {}

    // 投稿
    function postMessage(string memory _text) public {
        bytes memory tempEmptyStringTest = bytes(_text);
        require(tempEmptyStringTest.length != 0, "Text is Empty");
        require(
            tempEmptyStringTest.length <= maxLength,
            "Text is over maxLength"
        );

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

    // 投稿全件取得
    function getAllMessages()
        public
        view
        returns (MessageArrayLib.Message[] memory)
    {
        return messages.getAllMessages();
    }

    // いいね
    function updateFavorite(bytes32 _id) public {
        require(messages.exists(_id), "Not Found Message");

        EnumerableSet.Bytes32Set storage _favorites = addressTofavorites[
            msg.sender
        ];
        Counters.Counter storage _counter = favorites[_id];

        if (_favorites.contains(_id)) {
            _favorites.remove(_id);
            _counter.decrement();
            return;
        }

        _favorites.add(_id);
        _counter.increment();
    }

    // いいね取得
    function getFavoriteCountFromMessage(bytes32 _id)
        public
        view
        returns (Counters.Counter memory)
    {
        return favorites[_id];
    }

    // アカウント更新
    function updateAccount(string memory _name) public {
        accounts[msg.sender] = Account({id: payable(msg.sender), name: _name});
    }

    // アカウント取得
    function getAccount(address _address) public view returns (Account memory) {
        return accounts[_address];
    }

    // Only Owner
    // 最大文字数の変更
    function updateMaxLength(uint _maxLength) public onlyOwner {
        maxLength = _maxLength;
    }
}
