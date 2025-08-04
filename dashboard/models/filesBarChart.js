let allBreedData = [];

export async function fetchBreedData() {
    try {
        const res = await fetch('api/predictions-count-per-breed');
        if (!res.ok) throw new Error('Errore caricamento dati');
        allBreedData = await res.json();

        console.log("📦 Dati ricevuti:", allBreedData); // AGGIUNTA
        renderBreedProgressBars(allBreedData);
    } catch (e) {
        console.error(e);
    }
}


const maxNormal = 10;
const baseOverflow = 10;

function renderBreedProgressBars(data) {
    const container = document.getElementById('breedProgressBarsContainer');

    if (!container) {
        console.warn('Container non trovato: #breedProgressBarsContainer');
        return;
    }

    container.innerHTML = '';

    data.forEach(item => {
        const breedName = item.dog_breed || 'Sconosciuta';
        const count = item.predictionsCount || 0;

        let timesExceeded;
        if (count <= maxNormal) {
            timesExceeded = 1;
        } else {
            timesExceeded = 1 + Math.ceil((count - maxNormal) / baseOverflow);
        }

        const displayMax = maxNormal + (timesExceeded - 1) * baseOverflow;
        const percent = (count / displayMax) * 100;

        const wrapper = document.createElement('div');
        wrapper.style.marginBottom = '12px';

        const label = document.createElement('div');
        label.style.marginBottom = '4px';
        label.style.fontWeight = '600';

        label.textContent = `${breedName} - Versione ${timesExceeded} `;

        const barContainer = document.createElement('div');
        barContainer.style.position = 'relative';
        barContainer.style.width = '100%';
        barContainer.style.height = '22px';
        barContainer.style.background = '#eee';
        barContainer.style.borderRadius = '5px';
        barContainer.style.overflow = 'hidden';

        const bar = document.createElement('div');
        bar.style.height = '100%';
        bar.style.width = `${Math.min(percent, 100)}%`;
        bar.style.background = '#4caf50';
        bar.style.transition = 'width 0.5s';

        const text = document.createElement('div');
        text.textContent = `${count} / ${displayMax}`;
        text.style.position = 'absolute';
        text.style.top = '0';
        text.style.left = '50%';
        text.style.transform = 'translateX(-50%)';
        text.style.fontSize = '13px';
        text.style.fontWeight = 'bold';
        text.style.color = percent > 60 ? '#fff' : '#333';
        text.style.height = '100%';
        text.style.display = 'flex';
        text.style.alignItems = 'center';
        text.style.justifyContent = 'center';

        barContainer.appendChild(bar);
        barContainer.appendChild(text);
        wrapper.appendChild(label);
        wrapper.appendChild(barContainer);
        container.appendChild(wrapper);
    });
}






