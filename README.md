# 🌍 Air Quality Monitoring & Analysis Dashboard

**An interactive R Shiny dashboard for visualizing urban air pollution trends, patterns, and environmental conditions using time series analysis and forecasting.**

</div>

---

##  Table of Contents

- [Project Overview](#-project-overview)
- [Dashboard Features](#-dashboard-features)
- [Dataset](#-dataset)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Dashboard Tabs](#-dashboard-tabs)
- [Key Findings](#-key-findings)
- [Project Structure](#-project-structure)
- [Team](#-team)

---

## Project Overview

This project analyzes air quality data using time series techniques and develops an interactive environmental monitoring dashboard for visualizing pollution trends, patterns, and environmental conditions.

**Goals:**
- Monitor urban air quality across **6 pollutant indicators** (CO, NO2, NOx, O3, PM2.5, Temperature)
- Provide an interactive Shiny dashboard for real-time data exploration
- Identify temporal patterns and seasonal pollution trends
- Analyse inter-pollutant correlations
- Apply **ETS time series forecasting** with a 30-step prediction horizon
- Classify air quality into **AQI categories** for public health insight

---

##  Dashboard Features

| Feature | Description |
|---|---|
|  **KPI Value Boxes** | Real-time Average, Maximum, and Minimum for any selected pollutant |
| **Trend Line Chart** | Pollutant concentration over time with area fill |
|  **CO vs NO2 Comparison** | Dual-line chart comparing two key traffic pollutants |
|  **Correlation Heatmap** | Interactive RdBu heatmap showing Pearson r for all 6 variables |
|  **ETS Forecast** | 30-step ahead forecast with 95% confidence interval ribbon |
|  **Interactive Data Table** | Paginated, scrollable table with live observation filter |
| **Sidebar Controls** | Pollutant selector + observation count slider (100–1,845) |

---

##  Dataset

| Property | Detail |
|---|---|
| **Source** | UCI Machine Learning Repository — Air Quality Dataset |
| **Observations** | 1,845 rows |
| **Variables** | 7 columns |
| **Missing Values** | Encoded as `-200`, replaced with column means during preprocessing |

### Variable Definitions

| Variable | Type | Description | Unit |
|---|---|---|---|
| `CO` | Continuous | Carbon Monoxide concentration | µg/m³ (sensor) |
| `NO2` | Continuous | Nitrogen Dioxide concentration | µg/m³ (sensor) |
| `NOx` | Continuous | Total Nitrogen Oxides | µg/m³ (sensor) |
| `O3` | Continuous | Ozone concentration | µg/m³ (sensor) |
| `PM2.5` | Continuous | Fine Particulate Matter (<2.5µm) | µg/m³ (sensor) |
| `Temperature` | Continuous | Ambient temperature reading | Sensor units |
| `Category` | Ordinal | AQI classification | 1=Good, 2=Moderate, 3=Sensitive, 4=Unhealthy |

### AQI Category Distribution

| Category | Label | Count | Percentage |
|---|---|---|---|
| 1 | Good | 595 | 32.2% |
| 2 | Moderate | 515 | 27.9% |
| 3 | Unhealthy for Sensitive Groups | 195 | 10.6% |
| 4 | Unhealthy | 540 | 29.3% |

>  **39.9%** of all readings fall in Categories 3 or 4 — flagged as potentially harmful to human health.

---

##  Tech Stack

```
R                  → Core programming language
Shiny              → Web application framework
shinydashboard     → Dashboard layout and navigation UI
Plotly             → Interactive visualizations
dplyr              → Data manipulation and cleaning
forecast (ETS)     → Time series modelling and prediction
DT                 → Interactive paginated data table
```

---

##  Getting Started

### Prerequisites

Make sure you have **R (version 4.0+)** installed. Then install the required packages:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "plotly",
  "dplyr",
  "forecast",
  "DT"
))
```

### Running the App

**Option 1 — Clone and run locally:**

```bash
# Clone the repository
git clone https://github.com/chiomajaco6/Air-Quality-Monitoring-Analysis-Time-Series-Environmental-dashboard.git

# Navigate into the project folder
cd Air-Quality-Monitoring-Analysis-Time-Series-Environmental-dashboard
```

Then in R or RStudio:

```r
# Set working directory to the project folder
setwd("Air Quality Monitoring Analysis")

# Launch the dashboard
shiny::runApp("app.R")
```

**Option 2 — Run directly from GitHub:**

```r
shiny::runGitHub(
  repo = "Air-Quality-Monitoring-Analysis-Time-Series-Environmental-dashboard",
  username = "chiomajaco6",
  subdir = "Air Quality Monitoring Analysis"
)
```

The dashboard will open in your browser at `http://127.0.0.1:PORT`.

---

##  Dashboard Tabs

### 1.  Overview
- **Value Boxes**: Live Average, Max, and Min for the selected pollutant
- **Pollutant Trend**: Line chart of concentration over time
- **Distribution**: Histogram of pollutant frequency

### 2.  Time Series
- **Full Time Series**: Area-fill plot of the selected pollutant over all observations
- **CO vs NO2 Comparison**: Dual-line comparison chart for the two primary combustion pollutants

### 3.  Correlation
- **Heatmap**: Pearson correlation matrix for all 6 numeric variables, rendered with RdBu colorscale
- **Scatter Plot**: Selected pollutant vs Temperature to explore meteorological relationships

### 4.  Forecast
- **ETS Model**: Error-Trend-Seasonality model auto-fitted to the selected pollutant
- **30-Step Forecast**: Predicted values with 95% confidence interval ribbon
- Frequency set to `7` (weekly seasonality)

### 5.  Data Table
- Full filtered dataset rendered as a paginated, scrollable DT table
- Respects the observation slider — shows only the selected number of rows

---

##  Key Findings

1. **~40% of readings are harmful** — Categories 3 and 4 combined represent 39.9% of all observations, indicating a significant public health concern.

2. **CO, NO2, and NOx are highly correlated** (r > 0.94) — consistent with shared traffic and combustion emission sources.

3. **Temperature has negligible correlation with pollutants** (r ≈ 0.10) — pollution variation is source-driven, not meteorologically driven.

4. **ETS forecasting predicts a gradual downward trend** in CO over the next 30 time steps.

5. **Cyclic weekly fluctuations** are visible in pollutant levels — consistent with workday vs. weekend traffic patterns.

---

##  Project Structure

```
Air-Quality-Monitoring-Analysis-Time-Series-Environmental-dashboard/
│
├── Air Quality Monitoring Analysis/
│   ├── app.R                          # Main Shiny application
│   └── dataset.csv                    # Air quality dataset (1,845 obs)
│
├── screenshots/                       # Dashboard screenshots
│
├── Air_Quality_Monitoring_Analysis    # Project documentation (PDF/PPTX)
│   documentation.../
│
└── README.md                          # This file
```

---

## Team Members
 
- Orukwowu Godsson Onyekwere
- Okoli Ugonna Alexander
- Success Akukwe
- Mercy Chifurumnaya Iheakachukwu
- Desmond Ahamefula
- Eze Ferdinand Somto
- Dozie Chidiebube Celestine
- Ogbaji Ugochukwu Precious
- Nnamani Chukwuebuka Christian
- Ohuche David Kelechi
- Ekwebelem Gabriel Nnamdi
- Abraham Ebube Emmanuel
- Amobi Cindy Amarachi
- Okoro Enyi Reginald Chidera
- Ogbu Promise Ucha
- Alozie Chibueze Onyinyechi
- Ugwuzor Oluebube Praise
- Miracle Jonathan Nwabuife
- Emmanuel Chimaobi
- Bright Princewill Munachimso
- Anujuru Favour Chiagoziem
- Val-Chinagi Goodness Uchechi
- Chine Udodi Excel Okwuchukwu
- Uzoma Henry Chukwuebuka
- Chibuzor John
- Balogun John Munachimso
- Chinekezi David Chidiebere
- Uzoho Lazarus Emmanuel Onyedikachi
- David Ohemu Promise
- Opene Chukwudozie Israel
- Christian Victory Chibuike

>  **Note:** This team worked collaboratively on data collection, preprocessing, analysis, visualization, and model development to ensure the successful completion of the project.

---

## 📄 License

This project is licensed under the **MIT License** — feel free to use, modify, and distribute with attribution.

---
