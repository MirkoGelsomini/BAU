let accuracyChart;

const statusAccuracyEl = document.getElementById('status-accuracy');
const totalPredictionsEl = document.getElementById('totalPredictions');
const correctPredictionsEl = document.getElementById('correctPredictions');
const accuracyPercentageEl = document.getElementById('accuracyPercentage');

export async function fetchPredictionAccuracy() {
    statusAccuracyEl.textContent = 'Caricamento dati...';
    try {
        const res = await fetch('/api/prediction-accuracy');
        if (!res.ok) throw new Error('Errore nella risposta dal server');

        const data = await res.json();

        const total = Number(data.total_predictions);
        const correct = Number(data.correct_predictions);
        const accuracy = Number(data.accuracy_percentage);

        totalPredictionsEl.textContent = total;
        correctPredictionsEl.textContent = correct;
        accuracyPercentageEl.textContent = accuracy.toFixed(2) + '%';

        const ctx = document.getElementById('accuracyChart').getContext('2d');
        if (accuracyChart) accuracyChart.destroy();

        accuracyChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Corrette', 'Errate'],
                datasets: [{
                    data: [correct, total - correct],
                    backgroundColor: ['#4caf50', '#f44336'],
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: {
                        callbacks: {
                            label: ctx => `${ctx.label}: ${ctx.parsed} (${(ctx.parsed / total * 100).toFixed(2)}%)`
                        }
                    }
                }
            }
        });

        statusAccuracyEl.textContent = '';
    } catch (e) {
        console.error('Errore caricamento dati:', e);
        statusAccuracyEl.textContent = 'Errore nel caricamento dei dati.';
        totalPredictionsEl.textContent = '--';
        correctPredictionsEl.textContent = '--';
        accuracyPercentageEl.textContent = '--%';
        if (accuracyChart) accuracyChart.destroy();
    }
}

export async function fetchBreedAccuracy() {
    try {
        const res = await fetch('/api/breed-accuracy');
        const data = await res.json();

        const container = document.getElementById('breedChartsContainer');
        container.innerHTML = '';

        data.forEach((row, index) => {
            const breed = row.dog_breed || 'Sconosciuta';
            const total = Number(row.total);
            const correct = Number(row.correct);
            const incorrect = total - correct;

            const wrapper = document.createElement('div');
            wrapper.style.textAlign = 'center';
            wrapper.style.marginBottom = '10px';

            const canvas = document.createElement('canvas');
            canvas.id = `chart-${index}`;
            wrapper.appendChild(canvas);

            const accuracyPercent = ((correct / total) * 100).toFixed(2);
            const percentageText = document.createElement('p');
            percentageText.textContent = `Accuratezza: ${accuracyPercent}%`;
            percentageText.style.marginTop = '8px';
            percentageText.style.fontSize = '14px';
            percentageText.style.fontWeight = 'bold';
            percentageText.style.color = '#333';

            wrapper.appendChild(percentageText);
            container.appendChild(wrapper);

            const ctx = canvas.getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Corrette', 'Errate'],
                    datasets: [{
                        data: [correct, incorrect],
                        backgroundColor: ['#4caf50', '#f44336'],
                        hoverOffset: 10
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false },
                        title: {
                            display: true,
                            text: breed,
                            font: { size: 14 }
                        },
                        tooltip: {
                            callbacks: {
                                label: context => {
                                    const val = context.parsed;
                                    const percent = (val / total * 100).toFixed(2);
                                    return `${context.label}: ${val} (${percent}%)`;
                                }
                            }
                        }
                    }
                }
            });
        });
    } catch (err) {
        console.error('Errore caricamento accuratezza per razza:', err);
    }
}
