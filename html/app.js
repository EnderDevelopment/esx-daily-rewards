const app = document.getElementById('app');
const days = document.getElementById('days');
const toast = document.getElementById('toast');
let state = null;
let toastTimer;

const post = (event, body = {}) => fetch(`https://${GetParentResourceName()}/${event}`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
const claimedSet = () => new Set((state.claimed || []).map(Number));

function render(data) {
    state = data;
    document.getElementById('title').textContent = data.title || 'Daily Rewards';
    document.getElementById('subtitle').textContent = data.subtitle || '';
    const claimed = claimedSet();
    const current = Number(data.currentDay) || 1;
    const total = data.rewards.length;
    document.getElementById('progress-text').textContent = `Day ${current} of ${total}`;
    document.getElementById('claimed-text').textContent = `${claimed.size} claimed`;
    document.getElementById('progress-bar').style.width = `${Math.min(100, (claimed.size / total) * 100)}%`;
    days.innerHTML = '';
    data.rewards.forEach((reward, index) => {
        const day = index + 1;
        const isClaimed = claimed.has(day);
        const available = day === current && !isClaimed;
        const card = document.createElement('button');
        card.type = 'button';
        card.className = `day ${isClaimed ? 'claimed' : ''} ${available ? 'available' : ''} ${day > current ? 'lock' : ''}`;
        card.disabled = !available;
        card.innerHTML = `<span class="day-number">DAY ${day}</span><span class="state">${isClaimed ? '✓' : available ? 'CLAIM' : '•'}</span><div class="day-title">${escapeHtml(reward.label)}</div><div class="day-desc">${escapeHtml(reward.description || (day > current ? 'Locked for now' : 'Already claimed'))}</div>`;
        if (available) card.addEventListener('click', () => post('claim', { day }));
        days.appendChild(card);
    });
}

function escapeHtml(value) { const div = document.createElement('div'); div.textContent = value == null ? '' : String(value); return div.innerHTML; }
function showToast(message, kind) { toast.textContent = message; toast.className = `toast show ${kind || ''}`; clearTimeout(toastTimer); toastTimer = setTimeout(() => { toast.className = 'toast'; }, 3500); }

document.getElementById('close').addEventListener('click', () => post('close'));
document.addEventListener('keydown', event => { if (event.key === 'Escape' && !app.classList.contains('hidden')) post('close'); });
window.addEventListener('message', event => {
    const { action, data, message, kind } = event.data;
    if (action === 'open') { app.classList.remove('hidden'); render(data); }
    if (action === 'hide') app.classList.add('hidden');
    if (action === 'toast') showToast(message, kind);
});
