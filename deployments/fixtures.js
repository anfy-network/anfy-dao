const hre = require('hardhat');

let contracts, contractSettings;
if (hre.hardhatArguments && hre.hardhatArguments.network === 'goerli') {
  contracts = {
    oracles: '',
    pool: '',
    poolValidators: '',
    poolEscrow: '',
    stakedBnbToken: '',
    rewardBnbToken: '',
    stakeWiseToken: '',
    vestingEscrowFactory: '',
    merkleDrop: '',
    merkleDistributor: '',
    roles: '',
    contractChecker: '',
    proxyAdmin: '',
  };

  contractSettings = {
    admin: '',
    vestingEscrow: '',
  };
} else {
  contracts = {
    oracles: '',
    pool: '',
    poolValidators: '',
    poolEscrow: '',
    stakedBnbToken: '',
    rewardBnbToken: '',
    stakeWiseToken: '',
    vestingEscrowFactory: '',
    merkleDrop: '',
    merkleDistributor: '',
    roles: '',
    contractChecker: '',
    proxyAdmin: '',
  };

  contractSettings = {
    admin: '',
    vestingEscrow: '',
  };
}

module.exports = {
  contractSettings,
  contracts,
};