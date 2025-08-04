// ELEMENTI PER CANI PER UTENTE
const statusDogsEl = document.getElementById('status-dogs');
const tbody = document.querySelector('#dogs-table tbody');
const totalDogsEl = document.getElementById('totalDogs');
const searchInput = document.getElementById('searchUser');

// FUNZIONE PER CARICARE E MOSTRARE CANI PER UTENTE
export async function fetchDogsPerUser() {
    statusDogsEl.textContent = 'Caricamento dati...';
    try {
        const res = await fetch('/api/dogs-per-user');
        if (!res.ok) throw new Error('Errore nella risposta dal server');

        const data = await res.json();

        if (data.length === 0) {
            statusDogsEl.textContent = 'Nessun dato trovato.';
            tbody.innerHTML = '';
            totalDogsEl.textContent = '--';
            return;
        }

        data.sort((a, b) => b.dogsCount - a.dogsCount);

        tbody.innerHTML = '';
        data.forEach(row => {
            const tr = document.createElement('tr');
            tr.innerHTML = `<td>${row.userId}</td><td>${row.dogsCount}</td>`;
            tbody.appendChild(tr);
        });

        const totalDogs = data.reduce((sum, row) => sum + row.dogsCount, 0);
        totalDogsEl.textContent = totalDogs;

        statusDogsEl.textContent = '';
        filterTable();
    } catch (e) {
        console.error('Errore caricamento dati:', e);
        statusDogsEl.textContent = 'Errore nel caricamento dei dati.';
        tbody.innerHTML = '';
        totalDogsEl.textContent = '--';
    }
}

// FILTRO USERID NELLA TABELLA
export function filterTable() {
    const filter = searchInput.value.toLowerCase();
    const rows = tbody.querySelectorAll('tr');
    rows.forEach(row => {
        const userId = row.cells[0].textContent.toLowerCase();
        row.style.display = userId.includes(filter) ? '' : 'none';
    });
}

searchInput.addEventListener('input', filterTable);
