const AWS = require('aws-sdk')
const { Client } = require('pg');

const regionid = 'eu-west-1'

AWS.config.update({
    region: regionid
});

const healthPath = '/health';
const productsPath = '/books';
const addproduct = '/addBook';

exports.handler = async function (event) {
    console. log( 'Request event: ', event);
    let response;
    switch(true){
      case event.httpMethod === 'GET' && event.path === healthPath:
        response = buildResponse(200);
        break;
      case event.httpMethod === 'GET' && event.path === productsPath:
        response = await getProducts();
        break;
    //   case event.httpMethod === 'POST' && event. path === addproduct:
    //     response = await saveproduct (SSON.parse(event.body));
    //     break;
      default:
        response = buildResponse(400);
    }
    return response
} 

async function getProducts(){
    const queryResult = await query('SELECT * FROM books');
    return {
     statusCode: 200,
     headers: {
        'Content-Type': 'application/json'
     },
     "body": JSON.stringify(queryResult),

    }    
}
async function buildResponse(statusCode){
    return {
        statusCode: statusCode
    }
}

async function query (q) {
//const secretName = '';
const secretManager = new AWS.SecretsManager({ region: regionid });
const data = await secretManager.getSecretValue({ SecretId: secretName }).promise();
const secret = (data.SecretString);


const client = new Client({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  port: 5432
  });

    
    try {
    await client.connect();
    const res = await client.query(q);
    console.log(res.rows);
    return {
      statusCode: 200,
      body: JSON.stringify(res.rows),
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Error connecting to the database' }),
    };
  } finally {
    await client.end();
  }

  } 