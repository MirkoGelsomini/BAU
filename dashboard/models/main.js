import { fetchDogsPerUser } from './dogs.js';
import { fetchPredictionAccuracy, fetchBreedAccuracy } from './accuracy.js';
import { fetchBreedData } from './filesBarChart.js';


fetchDogsPerUser();
fetchPredictionAccuracy();
fetchBreedAccuracy();
fetchBreedData();


setInterval(fetchDogsPerUser, 60000);
setInterval(fetchPredictionAccuracy, 60000);
setInterval(fetchBreedAccuracy, 60000);
setInterval(fetchBreedData, 60000);
