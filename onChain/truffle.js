require('dotenv').config();

const HDWalletProvider = require('truffle-hdwallet-provider')

module.exports = {
  networks: {
    development: {
      host: localhost,
      port: process.env.PORT,
      network_id: "*" // Match any network id
    }
  }
};