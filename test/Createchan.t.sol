// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.23;

import {Test} from "@std/Test.sol";
import {Createchan} from "../src/Createchan.sol";

/// @title ContractNoArgs
/// @author sepyke.eth
/// @notice Example contract without args to be deployed with Createchan
contract ContractNoArgs {
  uint256 public value = 42;
}

/// @title ContractWithArgs
/// @author sepyke.eth
/// @notice Example contract with args to be deployed with Createchan
contract ContractWithArgs {
  uint256 public arg1;
  address public arg2;

  constructor(uint256 arg1_, address arg2_) {
    arg1 = arg1_;
    arg2 = arg2_;
  }
}

/// @title CreatechanTest
/// @author sepyke.eth
/// @notice Createchan test
contract CreatechanTest is Test {
  address deployer = vm.addr(0xB45ED);
  bytes32 salt = "createchan";

  Createchan createchan;

  function setUp() public {
    createchan = new Createchan();
  }

  /// @notice Deploy smart contract with no args
  function testDeployWithNoArgs() public {
    vm.startPrank(deployer);
    address deployed = createchan.deploy(
      salt,
      type(ContractNoArgs).creationCode
    );
    address predicted = createchan.getDeployed(deployer, salt);
    assertEq(deployed, predicted);
    vm.stopPrank();

    ContractNoArgs deployment = ContractNoArgs(deployed);
    assertEq(deployment.value(), 42);
  }

  /// @notice Deploy smart contract with args
  function testDeployWithArgs() public {
    vm.startPrank(deployer);
    // NOTE: create creationCode with the args
    uint256 arg1 = 12;
    address arg2 = deployer;
    bytes memory creationCode = abi.encodePacked(
      type(ContractWithArgs).creationCode,
      abi.encode(arg1, arg2)
    );
    address deployed = createchan.deploy(salt, creationCode);
    address predicted = createchan.getDeployed(deployer, salt);
    assertEq(deployed, predicted);
    vm.stopPrank();

    ContractWithArgs deployment = ContractWithArgs(deployed);
    assertEq(deployment.arg1(), arg1);
    assertEq(deployment.arg2(), arg2);
  }
}
