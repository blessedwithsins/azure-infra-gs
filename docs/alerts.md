# Monitoring OSDU using Alerts

Alerts can be created to monitor OSDU based on pre-defined log queries (also called scheduled query rules). Depending on the given frequency, the log query will be run
and an alert will be fired if the criteria is met. Using 'Action Groups' we can define the kind of action to be taken when the alert is fired.

## Create your own Alert

### Using the Azure portal.
1. [Create a log alert rule with Azure Portal](https://docs.microsoft.com/en-gb/azure/azure-monitor/alerts/alerts-log#create-a-log-alert-rule-with-the-azure-portal)
2. [How to write Alert Log Queries](https://docs.microsoft.com/en-gb/azure/azure-monitor/alerts/alerts-log-query)
3. [Understanding Action Groups](https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups#:~:text=1%20In%20the%20Azure%20portal%2C%20search%20for%20and,in%20the%20relevant%20fields%20in%20the%20wizard%20experience.)

### Using Terraform Templates

Terraform Template Alerts can be found [here](../infra/monitoring_resources/README.md).



