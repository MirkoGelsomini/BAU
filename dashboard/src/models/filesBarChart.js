let allBreedData = [];

export async function fetchBreedData() {
    try {
        const res = await fetch('api/predictions-count-per-breed');
        if (!res.ok) throw new Error('Error loading data');
        allBreedData = await res.json();

        console.log("📦 Data received:", allBreedData);
        renderBreedProgressBars(allBreedData);
    } catch (e) {
        console.error(e);
    }
}

const stepSize = 30;

function renderBreedProgressBars(data) {
    const container = document.getElementById('breedProgressBarsContainer');
    if (!container) {
        console.warn('Container not found: #breedProgressBarsContainer');
        return;
    }
    container.innerHTML = '';

    data.forEach(item => {
        const breedName = item.dog_breed || 'Unknown';
        const count = item.predictionsCount || 0;

        let timesExceeded = Math.ceil(count / stepSize);

        let displayMax;
        if (count % stepSize === 0 && count !== 0) {
            displayMax = (timesExceeded + 1) * stepSize;
            timesExceeded = timesExceeded + 1;
        } else {
            displayMax = timesExceeded * stepSize;
        }

        const percent = (count / displayMax) * 100;

        let barColor;
        if (percent < 30) {
            barColor = '#f44336';
        } else if (percent < 60) {
            barColor = '#ff9800';
        } else {
            barColor = '#4caf50';
        }

        const wrapper = document.createElement('div');
        wrapper.style.marginBottom = '12px';

        const label = document.createElement('div');
        label.style.marginBottom = '4px';
        label.style.fontWeight = '600';
        label.textContent = `${breedName} - Versione ${timesExceeded}`;

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
        bar.style.background = barColor;
        bar.style.transition = 'width 0.5s';

        const text = document.createElement('div');
        text.textContent = `${count} / ${displayMax}`;
        text.style.position = 'absolute';
        text.style.top = '0';
        text.style.left = '50%';
        text.style.transform = 'translateX(-50%)';
        text.style.fontSize = '13px';
        text.style.fontWeight = 'bold';
        text.style.color = '#333';  // testo nero
        text.style.height = '100%';
        text.style.display = 'flex';
        text.style.alignItems = 'center';
        text.style.justifyContent = 'center';
        text.style.pointerEvents = 'none';

        barContainer.appendChild(bar);
        barContainer.appendChild(text);
        wrapper.appendChild(label);
        wrapper.appendChild(barContainer);
        container.appendChild(wrapper);
    });
}



