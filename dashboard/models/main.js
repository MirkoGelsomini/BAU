import { fetchPredictionAccuracy, fetchBreedAccuracy } from './accuracy.js';
import { fetchBreedData } from './filesBarChart.js';


fetchPredictionAccuracy();
fetchBreedAccuracy();
fetchBreedData();


setInterval(fetchPredictionAccuracy, 60000);
setInterval(fetchBreedAccuracy, 60000);
setInterval(fetchBreedData, 60000);
