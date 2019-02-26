pragma solidity 0.4.23;

import "./DelegateContractV1.sol";
import "./StorageState.sol";
import "../Library/Ownable.sol";

contract DelegateContractV2 is StorageState {
    modifier onlyOwner() {
        require(msg.sender == _storage.getAddress("owner"));
        _;
    }

    function setNumberOfOwners(uint num) public   onlyOwner {
        _storage.setUint("total", num);
    
    }
    function getNumberOfOwners() public view returns (uint) {
        return _storage.getUint("total");
        
    }
}
