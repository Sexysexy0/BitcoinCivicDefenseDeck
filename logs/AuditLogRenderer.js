const fs = require('fs');

function renderAuditLog() {
  const log = JSON.parse(fs.readFileSync('./decks/AuditLog.json'));
  console.log("📊 Civic Risk Scores:");
  log.forEach(entry => {
    console.log(`🌀 ${entry.payloadHash} — ${entry.risk} — ${entry.emotionalAPR} — ${new Date(entry.timestamp * 1000).toLocaleString()}`);
  });
}

renderAuditLog();
