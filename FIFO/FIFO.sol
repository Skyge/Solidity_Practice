pragma solidity 0.4.23;

import "../Library/Ownable.sol";
import "../Library/SafeMath.sol";

contract FIFO is Ownable {
    // using SafeMath for uint256;
    
    // uint256 private _total;
    
    // struct Item{
    //     address _from;
    //     uint256 _amount;
    // }
    
    // Item[] public items;
    // mapping(address => Item) public itemByAddress;
    // mapping(address => uint256) private itemsByIndex;
    
    // function getTotal() public view returns (uint256) {
    //     return _total;
    // }
    
    // function getItemByIndex(address _searchAddress) public view returns (uint256) {
    //     require(itemByAddress[_searchAddress]._from != address(0), "Do not exist!");
    //     return itemsByIndex[_searchAddress];
    // }
    
    // function addItem(address _sender, uint256 _count) public onlyOwner returns (bool) {
    //     items.push(Item(_sender, _count));
    //     _total = _total.add(1);
    //     itemByAddress[_sender] = Item(_sender, _count);
    //     itemsByIndex[_sender] = _total.sub(1);
        
    //     return true;
    // }
    
    // function removeItem() public onlyOwner returns (bool) {
    //     require(_total > 0, "Empty items!");
    //     Item storage removal = items[0];
    //     delete itemByAddress[removal._from];
    //     delete itemsByIndex[removal._from];
    //     delete items[0];
    //     require(recycling(1, _total));
        
    //     return true;
    // }
    
    // function removeItemByAddress(address _toRemove) public onlyOwner returns (bool) {
    //     require(itemByAddress[_toRemove]._from != address(0), "Invalid address!");
    //     uint256 index = itemsByIndex[_toRemove];
    //     delete itemByAddress[_toRemove];
    //     delete itemsByIndex[_toRemove];
    //     delete items[index];
    //     require(recycling(index+1, _total));
        
    //     return true;
    // }

    // function recycling(uint256 _start, uint256 _round) internal returns (bool) {
    //     for (uint256 i = _start; i <= _round-1; i++) {
    //         items[i-1] = items[i];
    //     }
    //     delete items[_round-1];
    //     items.length--;
    //     _total = _total.sub(1);

    //     return true;
    // }

    address private _currentAddress;
    address private _toRemoveAddress;
    uint256 private _total;
    
    struct PlayerInfo{
        uint256 _ownAmount;
        address _account;
        address _lastAddress;
        address _nextAddress;
    }
    
    mapping(address => PlayerInfo) public players;

    function getTotal() public view returns (uint256) {
        return _total;
    }

    function getEndAddress() public view returns (address) {
        return _currentAddress;
    }

    function getStartAddress() public view returns (address) {
        return _toRemoveAddress;
    }

	/**
	 * @dev This is equal to push an element in the array list.
	 */
    function addPlayer(address _account, uint256 _amount) public  returns (bool) {
        if (_total == 0) {
            _toRemoveAddress = _account;
        }else {
            players[_currentAddress]._nextAddress = _account;
        }
        
        players[_account] = PlayerInfo(_amount, _account, _currentAddress, address(0));
        _currentAddress = _account;
        _total = _total + 1;
    }

	/**
	 * @dev This is equal to pop an element in the array list.
	 */
    function removePlayer() public  returns (bool) {
        address _temp = players[_toRemoveAddress]._nextAddress;
        delete players[_toRemoveAddress];
        players[_temp]._lastAddress = address(0);
        _toRemoveAddress = _temp;
        _total = _total - 1;
    }

	/**
	 * @dev This is equal to delete an element in the linked list.
	 */
    function removePlayerByAddress(address _toDelete) public  returns (bool) {
        address _tempLast = players[_toDelete]._lastAddress;
        address _tempNext = players[_toDelete]._nextAddress;
        
        delete players[_toDelete];
        players[_tempLast]._nextAddress = _tempNext;
        players[_tempNext]._lastAddress = _tempLast;
        _total = _total - 1;
    }
}
