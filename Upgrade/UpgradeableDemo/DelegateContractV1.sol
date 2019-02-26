pragma solidity 0.4.23;

import "../Library/SafeMath.sol";
import "./StorageState.sol";


contract DelegateContractV1 is StorageState {
    using SafeMath for uint256;
  
    function setNumberOfOwners(uint256 num) public {
        _storage.setUint("total", num);
    
    }
    function getNumberOfOwners() public view returns (uint256) {
        return _storage.getUint("total");
    }   
}
