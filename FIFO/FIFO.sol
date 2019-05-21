pragma solidity 0.4.23;

import "../Library/Ownable.sol";
import "../Library/SafeMath.sol";

contract FIFO is Ownable {
    using SafeMath for uint256;

    address private _endAddress;
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
        return _endAddress;
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
            players[_endAddress]._nextAddress = _account;
        }
        
        players[_account] = PlayerInfo(_amount, _account, _endAddress, address(0));
        _endAddress = _account;
        _total = _total.add(1);

        emit AddPlayer(_account, _amount);
    }

	/**
	 * @dev This is equal to pop an element in the array list.
	 */
    function removePlayer() public  returns (bool) {
        require(_isExist(_toRemoveAddress), "Already empty!");
        address _temp = players[_toRemoveAddress]._nextAddress;
        delete players[_toRemoveAddress];
        emit RemovePlayer(_toRemoveAddress);

        players[_temp]._lastAddress = address(0);
        _toRemoveAddress = _temp;
        if (_temp == address(0)) {
            _endAddress = address(0);
        }
        _total = _total.sub(1);
    }

	/**
	 * @dev This is equal to delete an element in the linked list.
	 */
    function removePlayerByAddress(address _toDeleteAddress) public  returns (bool) {
        require(_isExist(_toDeleteAddress), "Invalid address!");
        address _tempLastAddress = players[_toDeleteAddress]._lastAddress;
        address _tempNextAddress = players[_toDeleteAddress]._nextAddress;
        
        delete players[_toDeleteAddress];
        emit RemovePlayer(_toDeleteAddress);

        if (_tempLastAddress != address(0)) {
            players[_tempLastAddress]._nextAddress = _tempNextAddress;
        } else {
            _toRemoveAddress = _tempNextAddress;
        }

        if (_tempNextAddress != address(0)) {
            players[_tempNextAddress]._lastAddress = _tempLastAddress;
        } else {
            _endAddress = _tempLastAddress;
        }
        _total = _total.sub(1);
    }

    function _isExist(address _searchingAddress) internal view returns (bool) {
        return players[_searchingAddress]._account != address(0);
    }
}
