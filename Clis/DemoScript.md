# Script for CLI Demo

## Prerequisites/Nice to Have Tools

* [git scm](https://git-scm.com/)
* [git credential manager](https://github.com/Microsoft/Git-Credential-Manager-for-Windows/release)
* [nodejs](https://nodejs.org)
* [npm](https://www.npmjs.com/)
* [angular cli](https://cli.angular.io/)
  * npm install -g @angular/cli
* [dotnet cli](https://github.com/dotnet/cli)
  * Download .NET SDK [here](https://www.microsoft.com/net/learn/get-started/windows)
* [azure cli](https://docs.microsoft.com/cli/azure)
  * Can use Cloud Shell or standalone install [here](https://docs.microsoft.com/cli/azure/install-azure-cli)
* [gig - (git ignore creation) ](https://www.gitignore.io/docs#-use-command-line)
* [Cmder - Console Emulator](http://cmder.net/)
  * [Brad Wilson Post about Customizing](http://bradwilson.io/blog/anatomy-of-a-prompt#downloads)
  * I like to have touch to create an empty file

```powershell
<#
The following function and alias assignment
are for use with git to create files which
start with a period, e.g. .gitignore
#>
function touch_file
{new-item $args[0] -itemtype file}
new-alias -name touch -value touch_file
````

## Let There Be Demo!

### Create GitHub Repo

Go to [GitHub](https://github.com) and create a new repository, capturing the clone url. Next thing is to create a folder to hold our repo.

```cmd
mkdir SampleApp
cd SampleApp
touch README.md
```

Now we will edit the README

```markdown
This is a CLI Demo!!!
````

Now we create the local repo, add a custom .gitignore and push our local branch to remote

```markdown
# initialize your git repository locally
git init

# create .gitignore with already provided language/OS templates
gig visualstudio,visualstudiocode, angular,windows,linux

# adds everything changed from local to staging
git add .

# commits everything in staging to be ready to be pushed to Github
git commit -m "first commit"
git remote add origin **our git repo url**

# the "-u" is so that the next time your push you don't need to type "origin master"
git push -u origin master
````

Now we have a git repo pushed to the cloud.

### Making a Web Api with DOTNET CLI

```cmd
# create solution
dotnet new sln -n SampleApp

# create new webapi project
dotnet new webapi -n SampleApp.Api -o SampleApp.Api

# add new project to solution
dotnet sln .\SampleApp.Api.sln add .\SampleApp.Api\SampleApp.Api.csproj

# drill into folder and run application
cd SampleApp.Api
dotnet run
```

Open the browser and direct to the below url to see api return

https://localhost:5001/weatherforecast

```json
[{
    "dateFormatted": "5/3/2018",
    "temperatureC": 12,
    "summary": "Sweltering",
    "temperatureF": 53
}, {
    "dateFormatted": "5/4/2018",
    "temperatureC": 54,
    "summary": "Chilly",
    "temperatureF": 129
}, {
    "dateFormatted": "5/5/2018",
    "temperatureC": 4,
    "summary": "Warm",
    "temperatureF": 39
}, {
    "dateFormatted": "5/6/2018",
    "temperatureC": 10,
    "summary": "Warm",
    "temperatureF": 49
}, {
    "dateFormatted": "5/7/2018",
    "temperatureC": 19,
    "summary": "Balmy",
    "temperatureF": 66
}]
```

At this point, we have a working Api, we should probably commit our code

```powershell
git add -a
git commit -m "api v1"
git push
```

### Making a Spa with Angular Cli

After making sure you have nodejs, npm and angular cli installed, run some commands to create our app and install node_modules

```cmd
# create new minimal angular app without installing node modules or adding git files
ng new sampleapp-spa --skip-install --skip-git --minimal
cd sampleapp-spa

# install node modules
npm install
```

NPM Install will probably take a while, take this time to update some things in our projects

* For simplicity sake, Enable full access with Cors for our app to our Api (do not do this in a Production Environment, it is not a good idea). Do this my adding the below into your `Startup.cs` file in your api project

```csharp
      public void ConfigureServices(IServiceCollection services)
        {
            services.AddCors();
            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseCors(x => x
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader());

            app.UseMvc();
        }
```

We should also add some code that hits our api. We can do this by updating `app.component.ts` and `app.module.ts`

**app.component.ts**

```typescript
import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
@Component({
  selector: 'app-root',
  template: `
  <h1>Weather forecast</h1>

  <p>This component demonstrates fetching data from the server.</p>

  <p *ngIf="!forecasts"><em>Loading...</em></p>

  <table class='table' *ngIf="forecasts">
    <thead>
      <tr>
        <th>Date</th>
        <th>Temp. (C)</th>
        <th>Temp. (F)</th>
        <th>Summary</th>
      </tr>
    </thead>
    <tbody>
      <tr *ngFor="let forecast of forecasts">
        <td>{{ forecast.dateFormatted }}</td>
        <td>{{ forecast.temperatureC }}</td>
        <td>{{ forecast.temperatureF }}</td>
        <td>{{ forecast.summary }}</td>
      </tr>
    </tbody>
  </table>
  `,
  styles: []
})
export class AppComponent {
  title = 'app';
  public forecasts: WeatherForecast[];

  constructor(http: HttpClient) {
    http.get<WeatherForecast[]>('http://localhost:5000/api/weather').subscribe(result => {
      this.forecasts = result;
    }, error => console.error(error));
  }
}
interface WeatherForecast {
  dateFormatted: string;
  temperatureC: number;
  temperatureF: number;
  summary: string;
}
```

**app.module.ts**

```typescript
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';


@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    HttpClientModule,
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

Once npm is done, run our angular app

```powershell
ng serve -o
```

The App should get the data from the api. Awesome!!!

At this point, we have all the code locally working. We should probably commit our code before we deploy. Before we do, add the following lines to `.gitignore` since they are not needed.

```text
package-lock.json
dist/
```

### Deploying our Apps to the Cloud with Azure CLI

The Azure CLI gives you a complete experience for managing your Azure Resources from your local machine (you can also use Azure Cloud Shell, even from your phone!). There are a set of commands that we need to run to get both apps to the cloud. These steps are

1. Create a Resource Group to hold all the Web Apps we will create
2. Create an App Service Plan for our Apps (can be shared between the two, for simplicity, each app has it's own)
3. Publish Our App using **DOTNET CLI!!!**
4. Zip Up our publish artifacts
5. Deploy the zip file to App Service, more info [here](https://docs.microsoft.com/azure/app-service/app-service-deploy-zip)

One thing to note here is that there are a few better options to deploy our code, even in the command line (CI/CD, Cloud Sync, Template, etc). I chose to use ZIP because it is the easiest to do in a demo setting. It isn't really scalabale obviously.

```powershell
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

dotnet publish -c Release -o $publishFolder -r win-x86 --self-contained true 
cd publish

# zip artifacts
Compress-Archive -Path * -DestinationPath deployment.zip

# deploy zip folder to webapp
az webapp deployment source config-zip --resource-group $resourceGroup --name $webApiName --src deployment.zip

# get the url of the newly deployed app service and open in the browser
$site1 = az webapp show -n $webApiName -g $resourceGroup --query "defaultHostName" -o tsv
Start-Process https://$site1/weatherforecast

cd YOURSAMPLEAPP

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
```

And we validate it works and we are done. Super duper cool

### Clean up all the Azure Resources we created

```powershell
az group delete --name $resourceGroup
```

I hope you enjoyed the Demo, feel free to take this and have fun!
