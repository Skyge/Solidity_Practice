pragma solidity 0.4.23;

import "../Library/Ownable.sol";
import "../Library/SafeMath.sol";

contract FIFO is Ownable {
    using SafeMath for uint256;

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

    event AddPlayer(address indexed _account, uint256 _value);
    event RemovePlayer(address indexed _toRemove);

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
        _total = _total.add(1);

        emit AddPlayer(_account, _amount);
    }

	/**
	 * @dev This is equal to pop an element in the array list.
	 */
    function removePlayer() public  returns (bool) {
        require(_exist(_toRemoveAddress), "Already empty!");
        address _temp = players[_toRemoveAddress]._nextAddress;
        delete players[_toRemoveAddress];
        emit RemovePlayer(_toRemoveAddress);

        players[_temp]._lastAddress = address(0);
        _toRemoveAddress = _temp;
        _total = _total.sub(1);
    }

	/**
	 * @dev This is equal to delete an element in the linked list.
	 */
    function removePlayerByAddress(address _toDelete) public  returns (bool) {
        require(_exist(_toRemoveAddress), "Invalid address!");
        address _tempLast = players[_toDelete]._lastAddress;
        address _tempNext = players[_toDelete]._nextAddress;
        
        delete players[_toDelete];
        emit RemovePlayer(_toDelete);

        players[_tempLast]._nextAddress = _tempNext;
        if (_tempNext != address(0)) {
            players[_tempNext]._lastAddress = _tempLast;
        } 
        _total = _total.sub(1);
    }

    function _exist(address _searching) internal view returns (bool) {
        if (players[_searching]._account != address(0)) {
            return true;
        } else {
            return false;
        }
    }
}
