require("dotenv").config();

import {
  createRequest
} from "./ethereum";


const start = () => {

  let urlToQuery = 'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD';
  let attributeToFetch = 'USD';

  createRequest({
      urlToQuery,
      attributeToFetch
    })
    .then(restart)
    .catch(error);
};

const restart = () => {
  wait(process.env.TIMEOUT).then(start);
};

const wait = (milliseconds) => {
  return new Promise((resolve, reject) => setTimeout(() => resolve(), milliseconds));
};

const error = (error) => {
  console.error(error);
  restart();
};

export default start;