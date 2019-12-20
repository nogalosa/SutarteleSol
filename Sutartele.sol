pragma solidity >=0.4.22 <0.6.0;

contract Sutartele {
    
    address customer;
    address seller;
    address courier;
    
    int state = 0;
    string item;
    uint qty;
    uint256 shippingPrice;
    uint256 fullPrice;
    
    event ChangeState(int state);
    
    function setCustomerAddress(address _customer) public {
        customer = _customer;
    }
    function setSellerAddress(address _seller) public {
        seller = _seller;
    }
    function setCourierAddress(address _courier) public {
        courier = _courier;
    }
    
    function quoteItem(string _item, uint _qty) public {
        require(msg.sender == customer);
        item = _item;
        qty = _qty;
        setState(1);
    }
    
    function getItem() public constant returns (string, uint) {
        return (item, qty);
    }
    
    function setState(int _state) private {
        state = _state;
        emit ChangeState(_state);
    }
    
    function getState() public constant returns (int) {
        return state;
    }
    
    function setShippingPrice(uint _shippingPrice) public {
        require(msg.sender == courier);
        shippingPrice = _shippingPrice * 1 ether ;
        setState(3);
    }
    
    function getShippingPrice() public constant returns (uint) {
        require(msg.sender == courier || msg.sender == seller);
        return shippingPrice;
    }
    
    function sendFullPrice(uint _fullPrice) public {
        require(msg.sender == seller);
        fullPrice = _fullPrice * 1 ether;
        setState(4);
    }
    
    function getFullPrice() public constant returns (uint) {
        require(msg.sender == customer || msg.sender == seller);
        return fullPrice;
    }
    
    function payment() public payable {
        require(msg.sender == customer);
        setState(5);
    }
    
    function quoteShipping() public {
        require(msg.sender == seller);
        setState(2);
    }
    
    function delivered() public {
        require(msg.sender == courier);
        courier.transfer(shippingPrice);
        seller.transfer(fullPrice - shippingPrice);
        setState(6);
    }
    
    function cancel() public {
        require(msg.sender == seller);
        setState(0);
    }
    
    
    
}
