# Anfy DAO smart contracts

The AnfyDAO smart contracts for liquid non-custodial ETH2 staking.

We also support BNB staking. Check contracts for Binance chain.

## Architecture

AnfyDAO smart contracts architecture

![This is an image](/docs/diagram.png)

## Development

**NB!** You would have to define the `initialize` function for the contracts that don't have it when deploying for the first time.

1. Install dependencies:

   ```shell script
   yarn install
   ```

2. Compile optimized contracts:

   ```shell script
   yarn compile --optimizer
   ```

3. Update network parameters in `hardhat.config.js`. Learn more at [Hardhat config options](https://hardhat.org/config/).

4. Change [settings](./deployments/settings.js) if needed. 

5. Deploy AnfyDAO contracts to the preferred network:

   ```shell script
   yarn deploy-contracts --network goerli
   ```

## Contributing

Development of the project happens in the open on GitHub, and we are grateful to the community for contributing bug fixes and improvements.

### License

The project is [GNU AGPL v3](./LICENSE).
