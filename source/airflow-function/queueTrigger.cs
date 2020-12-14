using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Azure.Storage;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using System.IO;
using System.ComponentModel.Design.Serialization;
using System.Text.RegularExpressions;
using System.Text;

namespace MyFunctionProj
{
    public static class QueueTrigger
    {
        //[StorageAccount("AzureWebJobsStorage")]
        [FunctionName("queueTrigger")]
        public static void Run([QueueTrigger("airflowlogqueue")] string myQueueItem, ILogger log)
        {
            log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");

            // get blob url
            JObject o = JObject.Parse(myQueueItem);
            string blobUrl = (string)o["data"]["url"];
            string runID = blobUrl.Split("/")[5]; // the 2nd part after containerName
            string correlationId = blobUrl.Split("/")[9];
            log.LogInformation($"C# Queue trigger function processed: blobUrl - {blobUrl}");
            log.LogInformation($"C# Queue trigger function processed: correlationId - {correlationId}");
            string connection = GetEnvironmentVariable("AzureWebJobsStorage");
            string customerId = GetEnvironmentVariable("AzureLogWorkspaceCustomerId");
            string sharedKey = GetEnvironmentVariable("AzureLogWorkspaceSharedKey");
            string logName = GetEnvironmentVariable("AzureLogWorkspaceLogName");

            log.LogInformation(connection);

            // parse blob url
            BlobClient blob = new BlobClient(new Uri(blobUrl));
            // Get a reference to a container
            BlobContainerClient container = new BlobContainerClient(connection, blob.BlobContainerName);
            // get blob with authentication
            blob = container.GetBlobClient(blob.Name);

            // Download the blob
            Azure.Response<BlobDownloadInfo> blobDownloadInfo = blob.Download();

            MemoryStream memoryStream = new MemoryStream();
            const int bufferLength = 1024;
            int actual;
            byte[] buffer = new byte[bufferLength];
            while ((actual = blobDownloadInfo.Value.Content.Read(buffer, 0, bufferLength)) > 0)
            {
                memoryStream.Write(buffer, 0, actual);
            }

            memoryStream.Position = 0;
            StreamReader sr = new StreamReader(memoryStream);
            LogLineEntity logLineEntity = null;

            int lineNumber = 0;

            while (true)
            {
                var line = sr.ReadLine();
                lineNumber++;
                // started dealing a new line
                // [2020-08-24 03:22:52,180] {taskinstance.py:881} INFO - Starting attempt 1 of 2
                Regex timestamp = new Regex(@"(?<=\[)\d+\-\d+\-\d+\s\d+:\d+:\d+,\d+(?=\])"); // timestamp, start of the line
                Regex task = new Regex(@"(?<=\s\{).+(?=\}\s)");
                Regex logLevel = new Regex(@"(?<=\}\s)\w+(?=\s\-)");
                Regex content = new Regex(@"(?<=\}\s\w+\s\-\s).*");

                // in case reached the end of document, send the last record to log analytics
                if (string.IsNullOrEmpty(line))
                {
                    if (logLineEntity != null)
                    {
                        string json = JsonConvert.SerializeObject(logLineEntity);
                        //log.LogInformation($"Executing send last record: {json}");
                        ApiHelper.SendLogs(json: json, customerId: customerId, sharedKey: sharedKey, logName: logName, log: log);
                        
                    }
                    log.LogInformation($"Congrats!!! Job finished with {lineNumber} lines!");
                    // quit the entire loop
                    break;
                }

                // if line started with timeStamp
                Match m = timestamp.Match(line);
                if (m.Success)
                {
                    // before dealing next record, post last record to log analytics
                    if (logLineEntity != null)
                    {
                        string json = JsonConvert.SerializeObject(logLineEntity);
                        //log.LogInformation($"Executing send record: {json}");
                        ApiHelper.SendLogs(json: json, customerId: customerId, sharedKey: sharedKey, logName: logName, log: log);
                    }

                    // reset object
                    logLineEntity = new LogLineEntity();

                    // then start to deal the next record
                    logLineEntity.LogFileName = blobUrl;
                    logLineEntity.RunID = runID;
                    logLineEntity.CorrelationId = correlationId;
                    logLineEntity.LogTimestamp = m.Value;
                    logLineEntity.Task = task.Match(line).Value;
                    logLineEntity.LogLevel = logLevel.Match(line).Value;
                    logLineEntity.Content = content.Match(line).Value;
                    logLineEntity.LineNumber = lineNumber;

                }
                // line not starting with timestap, another line of content
                else
                {
                    logLineEntity.Content += "\r\n" + line;
                }
            }
        }

        public static string GetEnvironmentVariable(string name)
        {
            return System.Environment.GetEnvironmentVariable(name, EnvironmentVariableTarget.Process);
        }
    }

    public class LogLineEntity
    {
        public string LogTimestamp { get; set; }
        public string Task { get; set; }
        public string LogLevel { get; set; }
        public string Content { get; set; }
        public string LogFileName { get; set; }
        public string RunID { get; set; }
        public string CorrelationId { get; set; }
        public int LineNumber { get; set; }
    }
}