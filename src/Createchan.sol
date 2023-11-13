// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.23;

import {CREATE3} from "@solady/utils/CREATE3.sol";

/// @title Createchan
/// @author sepyke.eth
/// @notice CREATE3 Factory
/// @custom:contract security@vaultbird.com
contract Createchan {
  /// @notice Get address
  /// @param deployer Deployer address
  /// @param salt Deployment salt
  /// @return deployed Contract address
  function getDeployed(
    address deployer,
    bytes32 salt
  ) external view returns (address deployed) {
    salt = keccak256(abi.encodePacked(deployer, salt));
    deployed = CREATE3.getDeployed(salt);
  }

  /// @notice Deploy smart contract
  /// @param salt Deployment salt
  /// @param creationCode The contract creation code. e.g. type(MyContract).creationCode
  /// @return deployed Contract address
  function deploy(
    bytes32 salt,
    bytes memory creationCode
  ) external payable returns (address deployed) {
    salt = keccak256(abi.encodePacked(msg.sender, salt));
    deployed = CREATE3.deploy(salt, creationCode, msg.value);
  }
}
