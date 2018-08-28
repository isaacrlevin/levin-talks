cd ..\SampleApp\SampleApp.Api
az login
 az account set --subscription a07802f5-f8df-47d8-9b88-79ba55cfb396

# create some variables that will be used all over
$resourceGroup="levin-cli-demo"
$webApiName="levin-cli-demo-api"
$publishFolder="publish"

# create our resource group
az group create --location eastus --name $resourceGroup

# now the app service plan
az appservice plan create --name $webApiName --resource-group $resourceGroup --sku FREE

# and finally the web app
az webapp create --name $webApiName --resource-group $resourceGroup --plan $webApiName

# publish the app with dotnet cli
dotnet publish -c release -o $publishFolder
cd publish

# zip artifacts
Compress-Archive -Path * -DestinationPath deployment.zip

# deploy zip folder to webapp
az webapp deployment source config-zip --resource-group $resourceGroup --name $webApiName --src deployment.zip

# get the url of the newly deployed app service and open in the browser
$site1 = az webapp show -n $webApiName -g $resourceGroup --query "defaultHostName" -o tsv
Start-Process https://$site1/api/weather

cd ..
cd ..
cd .\sampleApp-spa

# build app with angular cli, this will create a folder called 'dist'
ng build
$webSpaName="levin-cli-demo-spa"
cd dist
cd .\sampleApp-spa

# zip dist folder, create app service, webapp and deploy
Compress-Archive -Path * -DestinationPath deployment.zip
az appservice plan create --name $webSpaName --resource-group $resourceGroup --sku FREE
az webapp create --name $webSpaName --resource-group $resourceGroup --plan $webSpaName
az webapp deployment source config-zip --resource-group $resourceGroup --name $webSpaName --src deployment.zip

# get url of new webapp and open
$site2 = az webapp show -n $webSpaName -g $resourceGroup --query "defaultHostName" -o tsv
Start-Process https://$site2