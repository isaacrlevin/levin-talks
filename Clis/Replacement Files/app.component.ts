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
    http.get<WeatherForecast[]>('https://localhost:5001/api/weather').subscribe(result => {
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