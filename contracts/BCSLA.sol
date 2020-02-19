pragma solidity >=0.4.18;

contract BCSLA {

  address public customer;
  address public operator;

  bool public customerPosted = false;
  bool public operatorPosted = false;

  uint public customerDeposit = 0;
  uint public operatorDeposit = 0;

  uint public operatorWithdrawal;
  uint public customerWithdrawal;

  uint public sla = 90;

  uint public customerMetrics = 100;
  uint public operatorMetrics = 100;
  uint public tolerance = 5;

  bool public slaStarted = false;

  event BCSLAStartsEvent(address customer, address operator);
  event EndOfRoundEvent(uint customerDeposit, uint operatorDeposit);
  event BCSLAInfringement(address customer, address operator, uint customerMetrics);

  constructor() public {
    /* Operator instantiates the contract */
    operator = msg.sender;
  }

  function registerAsACustomer() public {
    /* Customer register */
    require(customer == address(0));
    customer = msg.sender;
    emit BCSLAStartsEvent(operator, customer);
  }

  function postMetrics(uint x) public payable {
    require((msg.sender == operator || msg.sender == customer));
    if(msg.sender == operator) {
      operatorPosted = true;
      operatorDeposit = operatorDeposit + msg.value;
      operatorMetrics = x;
    }
    if(msg.sender == customer) {
      customerPosted = true;
      customerDeposit = customerDeposit + msg.value;
      customerMetrics = x;
    }
    if( customerPosted && operatorPosted ) {
      if ( customerMetrics == operatorMetrics ) {
	/* Metrics within tolerance sla applies */
	if ( customerMetrics < sla ) {
	  emit BCSLAInfringement(customer, operator, customerMetrics);
	  customer.transfer(customerDeposit+operatorDeposit);
	  customerDeposit = 0;
	  operatorDeposit = 0;
	} else {
	  if(msg.sender == customer) {
	    /* Refund customer/operator */
	    customer.transfer(customerDeposit);
	    operator.transfer(operatorDeposit);
	    customerDeposit = 0;
	    operatorDeposit = 0;
	  } else {
	    /* Refund operator/customer */
	    customer.transfer(customerDeposit);
	    operator.transfer(operatorDeposit);
	    customerDeposit = 0;
	    operatorDeposit = 0;
	  }
	}
      }
    }
  }

  function endOfRound() internal {
    operatorPosted = false;
    customerPosted = false;
    emit EndOfRoundEvent(operatorDeposit, customerDeposit);
  }

}
