// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";

library MessageArrayLib {
    using MessageArrayLib for Messages;

    // 投稿文の配列
    struct Messages {
        Message[] _items;
    }

    // 投稿文
    struct Message {
        // ID
        bytes32 id;
        // 投稿者
        address payable owner;
        // 内容
        string text;
        // 投稿日
        uint publishedAt;
    }

    function pushMessage(Messages storage self, Message memory _element)
        internal
    {
        if (!exists(self, _element.id)) {
            self._items.push(_element);
        }
    }

    function removeMessage(Messages storage self, Message memory element)
        internal
        returns (bool)
    {
        for (uint i = 0; i < self.size(); i++) {
            if (self._items[i].id == element.id) {
                self._items[i] = self._items[self.size() - 1];
                self._items.pop();
                return true;
            }
        }
        return false;
    }

    function getMessageAtIndex(Messages storage self, uint256 index)
        internal
        view
        returns (Message memory)
    {
        require(index < size(self), "the index is out of bounds");
        return self._items[index];
    }

    function size(Messages storage self) internal view returns (uint256) {
        return self._items.length;
    }

    function exists(Messages storage self, bytes32 element)
        internal
        view
        returns (bool)
    {
        for (uint i = 0; i < self.size(); i++) {
            if (self._items[i].id == element) {
                return true;
            }
        }
        return false;
    }

    function getAllMessages(Messages storage self)
        internal
        view
        returns (Message[] memory)
    {
        return self._items;
    }

    function fetchPage(
        Messages storage self,
        uint256 cursor,
        uint256 howMany
    ) internal view returns (Message[] memory values, uint256 newCursor) {
        uint256 length = howMany;
        if (length > self._items.length - cursor) {
            length = self._items.length - cursor;
        }

        values = new Message[](length);
        for (uint256 i = 0; i < length; i++) {
            values[i] = self._items[cursor + i];
        }

        return (values, cursor + length);
    }
}
