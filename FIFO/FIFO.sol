pragma solidity 0.4.23;

import "./Ownable.sol";
import "./SafeMath.sol";

contract FIFO is Ownable {
    using SafeMath for uint256;
    
    uint256 private _total;
    
    struct Item{
        address _from;
        uint256 _amount;
    }
    
    Item[] public items;
    mapping(address => Item) public itemByAddress;
    mapping(address => uint256) private itemsByIndex;
    
    function getTotal() public view returns (uint256) {
        return _total;
    }
    
    function getItemByIndex(address _searchAddress) public view returns (uint256) {
        require(itemByAddress[_searchAddress]._from != address(0), "Do not exist!");
        return itemsByIndex[_searchAddress];
    }
    
    function addItem(address _sender, uint256 _count) public onlyOwner returns (bool) {
        items.push(Item(_sender, _count));
        _total = _total.add(1);
        itemByAddress[_sender] = Item(_sender, _count);
        itemsByIndex[_sender] = _total.sub(1);
        
        return true;
    }
    
    function removeItem() public onlyOwner returns (bool) {
        require(_total > 0, "Empty items!");
        Item storage removal = items[0];
        delete itemByAddress[removal._from];
        delete itemsByIndex[removal._from];
        delete items[0];
        _total = _total.sub(1);
        
        return true;
    }
    
    function removeItemByAddress(address _toRemove) public onlyOwner returns (bool) {
        require(itemByAddress[_toRemove]._from != address(0), "Invalid address!");
        delete itemByAddress[_toRemove];
        delete items[itemsByIndex[_toRemove]];
        delete itemsByIndex[_toRemove];
        _total = _total.sub(1);
        
        return true;
    }
    
}