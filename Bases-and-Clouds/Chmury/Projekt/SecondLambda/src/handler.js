const AWS = require("aws-sdk");
const s3 = new AWS.S3();
const dynamoDB = new AWS.DynamoDB.DocumentClient();
const BUCKET_NAME = "clouds-project-storage";
const TABLE_NAME = "FileProcessingTickets";

const saveLogs = async (logData) => {
  const fileName = `logs/lambda-log.txt`;

  const params = {
    Bucket: BUCKET_NAME,
    Key: fileName,
    Body: `${JSON.stringify(logData, null, 2)}\n`,
    ContentType: 'application/json',
    ACL: 'private',
  };
  try {
    const existingData = await s3.getObject({ Bucket: BUCKET_NAME, Key: fileName }).promise();
    params.Body = existingData.Body + params.Body;
  } catch (error) {
    if (error.code !== 'NoSuchKey') {
      console.error('nieodcztane logi', error);
    }
  }

  try {
    await s3.putObject(params).promise();
    console.log(`zapisany: ${fileName}`);
  } catch (error) {
    console.error('niezapisany:', error);
  }
};

const updateTicketStatus = async (ticketId, status) => {
  const params = {
    TableName: TABLE_NAME,
    Key: { ticketId },
    UpdateExpression: "set #status = :status",
    ExpressionAttributeNames: {
      "#status": "status",
    },
    ExpressionAttributeValues: {
      ":status": status,
    },
  };
  await dynamoDB.update(params).promise();
};

exports.handler = async (event, context) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  for (const record of event.Records) {
    const message = JSON.parse(record.body);
    const { ticketId, username, fileName, base64File } = message;

    try {
      const decodedFile = Buffer.from(base64File, "base64");
      const params = {
        Bucket: BUCKET_NAME,
        Key: `${username}/${fileName}`,
        Body: decodedFile,
      };

      // Przesyłanie pliku do S3
      await s3.upload(params).promise();
      console.log(`File uploaded successfully for ticket ${ticketId}`);
      await saveLogs({
        timestamp: new Date().toISOString(),
        message: `File uploaded successfully for ticket ${ticketId} for user: ${username}`
      });

      // Aktualizacja statusu ticketu w DynamoDB
      await updateTicketStatus(ticketId, "Processed");
      console.log(`Ticket ${ticketId} updated to 'Processed'`);
      await saveLogs({
        timestamp: new Date().toISOString(),
        message: `Ticket updated succesfully for ticket: ${ticketId} for user: ${username}`
      });
    } catch (err) {
        await saveLogs({
            timestamp: new Date().toISOString(),
            message: `Error processing ticket ${ticketId} for user: ${username}`
        });
      console.error(`Error processing ticket ${ticketId}:`, err.message);
    }
  }
    await saveLogs({
        timestamp: new Date().toISOString(),
        message: `SQS messages processed successfully`
    });
  return { statusCode: 200, body: JSON.stringify({ message: "SQS messages processed successfully" }) };
};
