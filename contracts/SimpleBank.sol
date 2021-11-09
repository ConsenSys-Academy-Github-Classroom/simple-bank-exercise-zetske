pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

    /* State variables
     */

    mapping (address => uint) private balances ;
    mapping (address => bool) public enrolled;

    address public owner = msg.sender;
    
    /* Events - publicize actions to external listeners
     */
    
    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint amount);
    
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    /* Functions
     */

    function () external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() view public returns (uint) {
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      enrolled[msg.sender] = true;
      emit LogEnrolled(msg.sender);
      return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      require(enrolled[msg.sender] == true, 'user should be enrolled');
      balances[msg.sender] += msg.value;
      emit LogDepositMade(msg.sender, msg.value);
      return getBalance();
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
      require(withdrawAmount <= getBalance(), 'sender does not have enough funds');
      balances[msg.sender] -= withdrawAmount;
      msg.sender.transfer(withdrawAmount);
      emit LogWithdrawal(msg.sender, withdrawAmount, getBalance());
      return getBalance();
    }
}
