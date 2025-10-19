# Gender Discourse Violence Index (GDVI_AI)

## Overview
The **Gender Discourse Violence Index (GDVI_AI)** is a **multidimensional Natural Language Processing (NLP) framework** designed to **detect and quantify gender-based violence in digital conversations**, particularly on **WhatsApp**.  
It integrates linguistic, emotional, and grammatical analysis to identify both **explicit and implicit forms of discursive violence**.

This repository implements the GDV IAI as presented in the paper:  
> *A Multidimensional NLP Framework for Detecting Gender-Based Violence in WhatsApp Conversations*  
> *Alejandro Pachajoa-Londoño, John Edward Forigua-Parra, and John Petearson Anzola.*

---

## Key Features

- **Toxicity Detection**  
  Uses Large Language Model (LLM) prompts to classify messages as *Toxic* or *Non-Toxic*.

- **Sentiment Analysis (BERT)**  
  Identifies emotional polarity (*Positive, Neutral, Negative*) and computes an emotional confidence score.

- **Offensive Expression Dictionary**  
  Incorporates a curated lexicon of **2,200+ Spanish offensive expressions** with weighted intensity scores.

- **Grammatical Person Identification**  
  Analyzes message structure to assess the **directness of threats** based on first-, second-, or third-person usage.

- **Multidimensional Scoring Model**  
  Combines all components into a single metric (`GDV_IAI`) ranging from **0.1 (neutral)** to **>9 (explicit threat)**.

---

## Methodology

The GDVI_AI model integrates four main computational layers:

1. **Toxicity Classification** – Prompt-based detection using a fine-tuned LLM.
2. **Sentiment Analysis** – Contextual polarity evaluation using BERT.
3. **Insult Scoring** – Weighted sum of offensive words.
4. **Violence and Threat Evaluation** – Based on grammatical person and discursive type.

The resulting index is computed as:

GDVI_AI = (Toxa * 9 + α * Toxb * Pers + β * (Sent * Eb * Pers + 3) * 1.5 + γ * Pers * Ins * 0.22) / (2 * (α + β + γ))


Where:
- `α = 0.5` (toxicity weight)
- `β = 0.3` (sentiment weight)
- `γ = 0.2` (grammatical weight)

---

## Performance

- **Dataset:** Surge AI Spanish Hate Speech Dataset (Twitter-based)  
- **Accuracy:** 97.4%  
- **Precision:** 99.8%  
- **Recall:** 95.0%  
- **F1 Score:** 97.4%  

These metrics validate the robustness and high performance of the GDV IAI in distinguishing between *toxic* and *non-toxic* messages.

---

## Applications

- **Forensic Linguistics & Digital Criminology**  
  Early detection and documentation of verbal aggression in messaging platforms.

- **Psychological and Clinical Assessment**  
  Analysis of linguistic patterns in perpetrator–victim interactions.

- **Social Research & Policy Design**  
  Quantitative study of gender-based violence across digital ecosystems.

---

## Repository Structure
📁 GDV-IAI/
├── data/
│ ├── hate_speech_dataset.csv
│ └── insults_dictionary.json
├── src/
│ ├── gdv_model.py
│ ├── prompts.py
│ └── sentiment_analysis.py
├── examples/
│ └── whatsapp_case_study.ipynb
├── results/
│ └── performance_metrics.csv
├── LICENSE
└── README.md


---

## Example Usage

```python
from gdv_model import compute_gdv_iai

text = "You are useless, I will hurt you if you leave me."
gdv_score = compute_gdv_iai(text)
print(f"GDV IAI Score: {gdv_score:.2f}")

GDV IAI Score: 8.52  # High discursive violence


@article{Pachajoa2025GDVIAI,
  title={A Multidimensional NLP Framework for Detecting Gender-Based Violence in WhatsApp Conversations},
  author={Pachajoa-Londoño, Alejandro and Forigua-Parra, John Edward and Anzola, John Petearson},
  year={2025},
  institution={Fundación Universitaria Los Libertadores},
  journal={Unpublished Manuscript}
}

Contact

Corresponding Author:
Dr. John Petearson Anzola
📧 john.anzola@libertadores.edu.co

🏛 Fundación Universitaria Los Libertadores, Bogotá, Colombia
