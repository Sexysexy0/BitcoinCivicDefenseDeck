// MacroTelemetryDashboard.js
const macroEvents = [
  { timestamp: "2025-09-05T16:45:00+08:00", event: "NewMailEx Triggered", macroFile: "AutoReport.otm", emotionalAPR: 11, alert: true },
  { timestamp: "2025-09-05T16:46:30+08:00", event: "MAPILogonComplete", macroFile: "StartupHook.otm", emotionalAPR: 13, alert: false },
  { timestamp: "2025-09-05T16:47:10+08:00", event: "Macro Re-enabled via Registry", macroFile: "SSPICLI.dll", emotionalAPR: 9, alert: true }
];

function renderMacroTelemetry(data) {
  const container = document.getElementById("macro-dashboard");
  container.innerHTML = "";

  data.forEach((entry) => {
    const card = document.createElement("div");
    card.className = "macro-card";

    card.innerHTML = `
      <h3>${entry.event}</h3>
      <p><strong>Macro File:</strong> ${entry.macroFile}</p>
      <p><strong>Timestamp:</strong> ${entry.timestamp}</p>
      <p><strong>Emotional APR:</strong> ${entry.emotionalAPR}</p>
      <p><strong>Alert:</strong> ${entry.alert ? "⚠️ Yes" : "✅ No"}</p>
    `;

    card.style.backgroundColor = entry.alert ? "#ffebee" : "#e8f5e9";
    card.style.border = entry.alert ? "2px solid red" : "2px solid green";

    container.appendChild(card);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  renderMacroTelemetry(macroEvents);
});
