# Commodity Price Forecasting Using Machine Learning (MATLAB)

## Overview
This repository contains the code and experimental work from my **MSc dissertation in Data Science** at **Kingston University London**, focused on **forecasting commodity prices using statistical and deep learning models**.

The research investigates how advanced recurrent neural networks—particularly **Gated Recurrent Units (GRU)**—compare against classical time-series and regression methods when modelling volatile commodity markets.

---

## Research Motivation
Commodity markets are highly sensitive to:
- geopolitical events (e.g. COVID-19, Russia–Ukraine war),
- supply-demand shocks,
- macroeconomic uncertainty.

Traditional models often struggle to capture these non-linear dynamics.  
This work explores whether **deep learning models** can offer more robust and accurate forecasts.

---

## Data
- Source: **International Monetary Fund (IMF)**
- Coverage: **~120 commodities**
- Time range: **May 2013 – May 2023**
- Frequency: **Monthly**
- Focus variable: **closing prices**

Only **sample data** is included in this repository for reproducibility and ethics compliance.

---

## Methodology
The project followed a structured research pipeline:

1. Data loading and cleaning
2. Exploratory Data Analysis (EDA)
3. Correlation and volatility analysis
4. Feature selection and normalization
5. Model training and evaluation
6. Comparative performance analysis

---

## Models Implemented
### Statistical & Classical Models
- Moving Average
- Linear Regression
- ARIMA

### Deep Learning Models
- Long Short-Term Memory (LSTM)
- **Gated Recurrent Unit (GRU)**

All models were implemented in **MATLAB**, using:
- Statistics and Machine Learning Toolbox
- Deep Learning Toolbox

---

## Evaluation Metrics
Models were evaluated using:
- Root Mean Squared Error (RMSE)
- Mean Squared Error (MSE)

### Comparative Performance (RMSE)
| Model  | RMSE |
|------|------|
| Linear Regression | 0.0569 |
| ARIMA | 0.0631 |
| LSTM | 0.0493 |
| **GRU** | **0.0078** |

The **GRU model consistently outperformed** all baselines.

---

## Key Findings
- GRU captured long- and short-term temporal dependencies more effectively
- Statistical models struggled during periods of geopolitical disruption
- Normalization was critical for stable deep learning convergence
- GRU offered the best trade-off between accuracy and computational complexity

---

## Project Structure
src/ MATLAB implementations (ARIMA, LSTM, GRU, preprocessing)
data/ Sample datasets only
results/ Figures and evaluation outputs
docs/ Dissertation and summaries

---

## Academic Context
This work was submitted as part of the **MSc Data Science dissertation**  
and is shared here for **academic, research, and portfolio purposes**.

---

## Tools
- MATLAB
- Deep Learning Toolbox
- Statistical & ML Toolbox

---

## Ethics
- Data is publicly available (IMF)
- No private or sensitive information is included
- Original work with full academic attribution

## Research Summary
A condensed research summary of the MSc dissertation is available here:  
[PDF – MSc Dissertation Summary](docs/Deep Learning Approaches to Commodity Price Forecasting.pdf)


