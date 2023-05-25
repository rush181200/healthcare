const aws = require("aws-sdk");
const dynamo = new aws.DynamoDB.DocumentClient();

const registerPath = "/register";
const loginPath = "/login";
const verifyPath = "/verify";
const userPath = "/users";
const doctorPath = "/doctor";
const bookingPath = "/booking";

aws.config.update({
  region: "us-east-2",
});

exports.handler = async (event) => {
  let response;
  console.log(event.path);
  switch (event.path) {
    case "/users":
      switch (event.httpMethod) {
        case "POST":
          console.log("no doctor");
          response = await saveUser(JSON.parse(event.body));
          break;
        case "GET":
          response = await getUsers();
          break;
        case "PUT":
          let body = JSON.parse(event.body);
          console.log(body.updateValue);
          console.log("Getting into PUT");
          response = await updateUsers(
            body.id,
            body.updateKey,
            body.updateValue
          );
          break;
        case "DELETE":
          console.log(JSON.parse(event.body).id);
          response = await deleteUser(JSON.parse(event.body).id);
          break;
        default:
          response = buildResponse(404, "404 Not Found");
          break;
      }
      break;

    case "/booking":
      switch (event.httpMethod) {
        case "POST":
          response = await saveBooking(JSON.parse(event.body));
          break;
        case "GET":
          response = await getBooking();
          break;
        case "PUT":
          let body = JSON.parse(event.body);
          response = await updateBooking(
            body.bid,
            body.updateKey,
            body.updateValue
          );
          break;
        //   case 'DELETE':
        //       console.log(JSON.parse(event.body).bid)
        //       response = await deleteBooking(JSON.parse(event.body).bid);
        default:
          response = buildResponse(404, "404 Not Found");
          break;
      }

      break;

    case "/doctor":
      switch (event.httpMethod) {
        case "POST":
          console.log("doctor");
          response = await saveDoc(JSON.parse(event.body));
          break;
        case "GET":
          response = await getDoc();
          break;
        case "PUT":
          let body = JSON.parse(event.body);
          console.log(body.updateValue);
          console.log("Getting into PUT");
          response = await updateDoc(body.id, body.updateKey, body.updateValue);
          break;
        case "DELETE":
          console.log(JSON.parse(event.body).id);
          response = await deleteDoc(JSON.parse(event.body).id);
          break;
        default:
          response = buildResponse(404, "404 Not Found");
          break;
      }
      break;

    default:
      response = buildResponse(404, "404 Not Found");
      break;
  }

  return response;
};

// -------------------------Bookings--------------------------------------------
async function updateBooking(id, updateKey, updateValue) {
  if (!updateValue) {
    const error = new Error("updateValue is empty");
    return buildResponse(400, {
      Operation: "Update",
      Message: "Failed",
      Error: error.message,
    });
  }

  const params = {
    TableName: "bookings",
    Key: {
      bid: id,
    },
    UpdateExpression: `set #attrName = :value`,
    ExpressionAttributeValues: {
      ":value": updateValue,
    },
    ExpressionAttributeNames: {
      "#attrName": updateKey,
    },
    ReturnValues: "UPDATED_NEW",
  };
  try {
    const response = await dynamo.update(params).promise();
    const body = {
      Operation: "Update",
      Message: "Success",
      Item: response,
    };
    return buildResponse(200, body);
  } catch (error) {
    console.log(error);
    const body = {
      Operation: "Update",
      Message: "Failed",
      Error: error.message,
    };
    return buildResponse(500, body);
  }
}

async function saveBooking(requestBody) {
  const params = {
    TableName: "bookings",
    Item: requestBody,
  };

  try {
    await dynamo.put(params).promise();
    const body = {
      Operation: "SAVE",
      Message: "Success",
      Item: requestBody,
    };
    return buildResponse(200, body);
  } catch (error) {
    console.log(error);
    const body = {
      Operation: "SAVE",
      Message: "Failed",
      Error: error.message,
    };
    return buildResponse(500, body);
  }
}

async function getBooking() {
  const params = {
    TableName: "bookings",
  };
  const allUsers = await dynamo.scan(params).promise();
  const body = {
    bookings: allUsers,
  };
  return buildResponse(200, body);
}

// ------------------Doctor-----------------------------------------------------

async function deleteDoc(id) {
  const params = {
    TableName: "doctors",
    Key: {
      did: id,
    },

    ReturnValues: "ALL_OLD",
  };

  return await dynamo
    .delete(params)
    .promise()
    .then(
      (response) => {
        const body = {
          Operation: "Delete",
          Message: "Success",
          Item: response,
        };
        return buildResponse(200, body);
      },
      (error) => {
        return buildResponse(500, error);
      }
    );
}

async function getDoc() {
  const params = {
    TableName: "doctors",
  };
  const allUsers = await dynamo.scan(params).promise();
  const body = {
    doctor: allUsers,
  };
  return buildResponse(200, body);
}

async function saveDoc(requestBody) {
  const params = {
    TableName: "doctors",
    Item: requestBody,
  };

  try {
    await dynamo.put(params).promise();
    const body = {
      Operation: "SAVE Doctor",
      Message: "Success",
      Item: requestBody,
    };
    return buildResponse(200, body);
  } catch (error) {
    console.log(error);
    const body = {
      Operation: "SAVE",
      Message: "Failed",
      Error: error.message,
    };
    return buildResponse(500, body);
  }
}
// -------------------Users-----------------------------------------------------------

async function deleteUser(id) {
  const params = {
    TableName: "users",
    Key: {
      id: id,
    },

    ReturnValues: "ALL_OLD",
  };

  return await dynamo
    .delete(params)
    .promise()
    .then(
      (response) => {
        const body = {
          Operation: "Delete",
          Message: "Success",
          Item: response,
        };
        return buildResponse(200, body);
      },
      (error) => {
        return buildResponse(500, error);
      }
    );
}

async function updateUsers(id, updateKey, updateValue) {
  if (!updateValue) {
    const error = new Error("updateValue is empty");
    return buildResponse(400, {
      Operation: "Update",
      Message: "Failed",
      Error: error.message,
    });
  }

  const params = {
    TableName: "users",
    Key: {
      id: id,
    },
    UpdateExpression: `set #attrName = :value`,
    ExpressionAttributeValues: {
      ":value": updateValue,
    },
    ExpressionAttributeNames: {
      "#attrName": updateKey,
    },
    ReturnValues: "UPDATED_NEW",
  };
  try {
    const response = await dynamo.update(params).promise();
    const body = {
      Operation: "Update",
      Message: "Success",
      Item: response,
    };
    return buildResponse(200, body);
  } catch (error) {
    console.log(error);
    const body = {
      Operation: "Update",
      Message: "Failed",
      Error: error.message,
    };
    return buildResponse(500, body);
  }
}

async function getUsers() {
  const params = {
    TableName: "users",
  };
  const allUsers = await dynamo.scan(params).promise();
  const body = {
    users: allUsers,
  };
  return buildResponse(200, body);
}

async function saveUser(requestBody) {
  const params = {
    TableName: "users",
    Item: requestBody,
  };

  try {
    await dynamo.put(params).promise();
    const body = {
      Operation: "SAVE",
      Message: "Success",
      Item: requestBody,
    };
    return buildResponse(200, body);
  } catch (error) {
    console.log(error);
    const body = {
      Operation: "SAVE",
      Message: "Failed",
      Error: error.message,
    };
    return buildResponse(500, body);
  }
}

function buildResponse(statusCode, body) {
  return {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  };
}
