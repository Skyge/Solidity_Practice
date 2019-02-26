pragma solidity 0.4.23;

import "../Library/Ownable.sol";
import "./StorageState.sol";

contract Proxy is StorageState , Ownable {
    address public _implementation;

    event Upgraded(address indexed implementation);

    constructor(KeyStorageContract storage_, address _owner) public {
        _storage = storage_;
        _storage.setAddress("owner", _owner);
    }

    function implementation() public view returns (address) {
        return _implementation;
    }

    function upgradeTo(address impl) public onlyOwner {
        require(_implementation != impl);
        _implementation = impl;
        emit Upgraded(impl);
    }
 
    function () public payable {
        address _impl = implementation();
        require(_impl != address(0));
        bytes memory data = msg.data;

        assembly {
            let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
            let size := returndatasize
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}
