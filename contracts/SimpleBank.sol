pragma solidity ^0.8.0;

contract SimpleBank {
    address public owner;
    mapping(address => uint) private balances;
    mapping(address => bool) public frozenAccounts;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier notFrozen() {
        require(!frozenAccounts[msg.sender], "Account is frozen");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Deposit ETH into the bank
    function deposit() public payable notFrozen {
        require(msg.value > 0, "Deposit must be more than 0");
        balances[msg.sender] += msg.value;
    }

    // Withdraw ETH from the bank
    function withdraw(uint _amount) public notFrozen {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    // View your balance
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    // Admin: Freeze or unfreeze a user
    function setFreeze(address _user, bool _freeze) public onlyOwner {
        frozenAccounts[_user] = _freeze;
    }

    // Admin: Check any user's balance
    function viewUserBalance(address _user) public view onlyOwner returns (uint) {
        return balances[_user];
    }

    // Fallback to accept ETH directly
    receive() external payable {
        deposit();
    }
}
