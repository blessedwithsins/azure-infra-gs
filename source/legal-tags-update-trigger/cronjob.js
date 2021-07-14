const axios = require("axios");
const config = require("./config");
const telemetryUtils = require("./utils/telemetryUtils");
const qs = require("querystring");
const axiosRetry = require('axios-retry');

axiosRetry(axios, { retries: 3, retryDelay: axiosRetry.exponentialDelay });

const generateToken = async () => {
  try {
    const res = await axios.post(
      config.api_host.auth,
      qs.stringify(config.auth_params)
    );
    telemetryUtils.passApiRequest(config.api_host.auth, qs.stringify(config.auth_params));
    return "Bearer " + res.data.access_token;
  } catch (err) {
    telemetryUtils.failApiRequest(config.api_host.auth, err, qs.stringify(config.auth_params));
  }
};

const getListOfPartitions = async (token) => {
  const authHeader = {
    Authorization: `${token}`,
  };
  const endpoint = `${config.api_host.partition}/partitions/`;
  try {
    const res = await axios.get(endpoint, {
      headers: authHeader,
    });
    telemetryUtils.passApiRequest(endpoint, token);
    return res.data;
  } catch (err) {
    telemetryUtils.failApiRequest(endpoint, err, token);
  }
};

const sendLegalTagUpdateRequest = async (token, partition) => {
  const authHeader = {
    Authorization: `${token}`,
    "data-partition-id": `${partition}`,
  };
  const endpoint = `${config.api_host.legal}/jobs/updateLegalTagStatus`;
  try {
    const res = await axios.get(endpoint, {
      headers: authHeader,
    });
    telemetryUtils.passApiRequest(endpoint, partition);
  } catch (err) {
    telemetryUtils.failApiRequest(endpoint, err, partition);
  }
};

generateToken().then((token) => {
  getListOfPartitions(token).then((listOfPartitions) => {
    listOfPartitions.forEach((partition) => {
      sendLegalTagUpdateRequest(token, partition);
    });
  });
});
