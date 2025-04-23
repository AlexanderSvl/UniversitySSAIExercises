
const canvas = document.getElementById("pressureCanvas");
const ctx = canvas.getContext("2d");

const drawGauge = (value) => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    const centerX = 175;
    const centerY = 195;
    const radius = 150;

    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
    ctx.fillStyle = "#ccc";
    ctx.fill();

    ctx.beginPath();
    ctx.arc(centerX, centerY, radius - 10, 0, 2 * Math.PI);
    ctx.fillStyle = "#1a1a1a";
    ctx.fill();

    ctx.strokeStyle = "#ffffff";
    ctx.fillStyle = "#ffffff";
    ctx.font = "16px sans-serif";
    ctx.lineWidth = 2;
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";

    for (let i = 0; i <= 60; i += 10) {
        const angle = Math.PI * (0.75 + (i / 60) * 1.5);
        const innerTick = radius - 20;
        const outerTick = radius - 10; // pulled back from the edge
    
        const x1 = centerX + innerTick * Math.cos(angle);
        const y1 = centerY + innerTick * Math.sin(angle);
        const x2 = centerX + outerTick * Math.cos(angle);
        const y2 = centerY + outerTick * Math.sin(angle);
    
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.stroke();
    
        const labelX = centerX + (radius - 35) * Math.cos(angle);
        const labelY = centerY + (radius - 35) * Math.sin(angle);
        ctx.fillText(i.toString(), labelX, labelY);
    }    

    ctx.fillStyle = "red";
    ctx.font = "bold 20px sans-serif";
    ctx.fillText("SAAS", centerX, centerY - 30);

    const needleAngle = (value / 60) * 1.5 * Math.PI + 0.75 * Math.PI;
    const needleX = centerX + (radius - 60) * Math.cos(needleAngle);
    const needleY = centerY + (radius - 60) * Math.sin(needleAngle);
    ctx.beginPath();
    ctx.moveTo(centerX, centerY);
    ctx.lineTo(needleX, needleY);
    ctx.strokeStyle = "white";
    ctx.lineWidth = 4;
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(centerX, centerY, 10, 0, 2 * Math.PI);
    ctx.fillStyle = "#000";
    ctx.fill();

    ctx.fillStyle = "white";
    ctx.font = "bold 18px sans-serif";
    ctx.fillText("BOOST", centerX, centerY + 90);
    ctx.font = "24px Arial";
    ctx.fillStyle = "black";
    ctx.fillText(`${value.toFixed(1)} PSI`, centerX, centerY - 180);
};


let currentValue = 10;
const animate = () => {
    const newValue = Math.random() * 60;
    const steps = 30;
    let step = 0;
    const delta = (newValue - currentValue) / steps;

    const interval = setInterval(() => {
        currentValue += delta;
        drawGauge(currentValue);
        step++;
        if (step >= steps) {
            clearInterval(interval);
            setTimeout(animate, 2000);
        }
    }, 30);
};

drawGauge(currentValue);
animate();

// =================== TEMPERATURE BAR ======================
const tempCanvas = document.getElementById("tempCanvas");
const tempCtx = tempCanvas.getContext("2d");
let currentTemp = 20;

function drawTemperature(temp) {
    tempCtx.clearRect(0, 0, tempCanvas.width, tempCanvas.height);

    const totalSegments = 20; // 100°C / 5°C
    const segmentWidth = 20; 
    const segmentGap = 5;
    const barStartX = 10;
    const barStartY = 180;
    const barHeight = 60;

    const activeSegments = Math.floor(temp / 5);

    // Draw each segment
    for (let i = 0; i < totalSegments; i++) {
        const x = barStartX + i * (segmentWidth + segmentGap);
        tempCtx.beginPath();
        tempCtx.rect(x, barStartY, segmentWidth, barHeight);
        tempCtx.fillStyle = i < activeSegments ? "#ff3333" : "#333";
        tempCtx.fill();
        tempCtx.strokeStyle = "#999";
        tempCtx.stroke();
    }

    // Temperature display above the bar
    tempCtx.fillStyle = "black";
    tempCtx.font = "24px Arial";
    tempCtx.textAlign = "center";
    tempCtx.fillText(`${temp.toFixed(1)} °C`, tempCanvas.width / 2, 100);
}

function animateTemperature() {
    const newTemp = 20 + Math.random() * 50; // Between 60°C and 80°C
    const steps = 30;
    let step = 0;
    const delta = (newTemp - currentTemp) / steps;

    const interval = setInterval(() => {
        currentTemp += delta;
        drawTemperature(currentTemp);
        step++;
        if (step >= steps) {
            clearInterval(interval);
            setTimeout(animateTemperature, 2000);
        }
    }, 30);
}

drawTemperature(currentTemp);
animateTemperature();

// ================= CO CONCENTRATION BAR ===================
const coCanvas = document.getElementById("coCanvas");
const coCtx = coCanvas.getContext("2d");
let currentCO = 600;

function drawCO(value) {
    coCtx.clearRect(0, 0, coCanvas.width, coCanvas.height);

    coCtx.fillStyle = "black";
    coCtx.font = "20px Arial";
    coCtx.textAlign = "center";
    coCtx.fillText(`${value.toFixed(0)} ppm`, coCanvas.width / 2, 30);

    // Background line
    coCtx.strokeStyle = "#333";
    coCtx.lineWidth = 4;
    coCtx.beginPath();
    coCtx.moveTo(30, 150);
    coCtx.lineTo(320, 150);
    coCtx.stroke();

    // CO bar level
    const maxBarLength = 290;
    const barLength = Math.min(value / 2000 * maxBarLength, maxBarLength);

    coCtx.fillStyle = "limegreen";
    coCtx.fillRect(30, 140, barLength, 20);
}

function animateCO() {
    const newCO = 800 + Math.random() * 1200; // 800–2000 ppm
    const steps = 30;
    let step = 0;
    const delta = (newCO - currentCO) / steps;

    const interval = setInterval(() => {
        currentCO += delta;
        drawCO(currentCO);
        step++;
        if (step >= steps) {
            clearInterval(interval);
            setTimeout(animateCO, 2000);
        }
    }, 30);
}

drawCO(currentCO);
animateCO();
