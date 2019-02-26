pragma solidity 0.4.23;

contract KeyStorageContract {

    mapping(address => mapping(bytes32 => uint256)) _uintStorage;
    mapping(address => mapping(bytes32 => address)) _addressStorage;

    function getUint(bytes32 key) public view returns (uint) {
        return _uintStorage[msg.sender][key];
    }

    function setUint(bytes32 key, uint value) public {
        _uintStorage[msg.sender][key] = value;
    }

    function getAddress(bytes32 key) public view returns (address) {
        return _addressStorage[msg.sender][key];
    }

    function setAddress(bytes32 key, address value) public {
        _addressStorage[msg.sender][key] = value;
    }
}
