# OnPremGateway

Scripts for aiding the use of On Prem Data Gateways.

## Map Gateways

For more information on this, [visit my blog]('https://www.mikaelsand.se/öasödalsjd'). Here is the short version:

- This creates a better overview than given by the Gateway management page.
- Must run on PS 7.x
- Install the [DataGateway Module]('https://docs.microsoft.com/en-us/powershell/module/datagateway/?view=datagateway-ps').
- Update the Region array on row 9.
- Log in using your Gateway admin account
- Run the script and wait.
- Look at the generated CSV-file.

| Header      | Description |
| ----------- | ----------- |
| ClusterName      | I thing you can figure this out       |
| MemeberGateways   | A list of all gateways in the cluster        |
|GatewayMachines| A list of all the machinenames connected to the cluster (hosting a gateway service) |
|Cluster Status|Is it online (live) or not|
|Version Status|If "Upgrate is required": Update your gateway installation.|

### Access rights

In order to get data about the gateways you need to have the correct access rights for the given region. 

More information can be found on the [On-premises data gateway management]('https://docs.microsoft.com/en-us/power-platform/admin/onpremises-data-gateway-management') page.
