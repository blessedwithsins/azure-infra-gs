const axios = require("axios");
const config = require("./config");
const qs = require("querystring");

const generateToken = async () => {
  try {
    const res = await axios.post(
      config.api_host.auth,
      qs.stringify(config.auth_params)
    );
    // log success
    return "Bearer " + res.data.access_token;
  } catch (err) {
    // log error
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
    // log success
    return res.data;
  } catch (err) {
    // log error
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
    // log success
  } catch (err) {
    // log error
  }
};

generateToken().then((token) => {
  getListOfPartitions(token).then((listOfPartitions) => {
    listOfPartitions.forEach((partition) => {
      sendLegalTagUpdateRequest(token, partition);
    });
  });
});
