# student-exam-performance-sql
Student Exam Performance SQL Analysis

Project Overview
This repository contains an exploratory data analysis (EDA) using SQL to investigate the primary factors influencing student exam performance. The goal of this project is to analyze how academic habits, study preparation, well-being, stress levels, and socioeconomic metrics impact final examination outcomes.The dataset contains comprehensive performance data, including historical performance metrics, habit metrics (sleep, study time, screen time), well-being metrics (stress, anxiety, physical activity), and demographic information (family income, parent education, internet access).

Key Findings & SQL Queries
1. Habit & Score Segmentation (01_score_ranges_vs_habits.sql)
Grouped exam scores into 10-point ranges to analyze trends in daily study hours, screen time, and sleep. As an insight, higher-performing score brackets consistently correlate with increased daily study hours and balanced sleep patterns.

2. Difficulty vs. Score Comparison (02_difficulty_vs_avg_score.sql & 02_difficulty_vs_avg_score_2.sql)
Evaluated overall student performance grouped by exam difficulty tiers to benchmark average score variation across test formats.

4. Metric Correlation Matrix (01_corr_metrics_with_exam_score.sql)
Evaluated linear relationships using PostgreSQL's CORR() and unpivoting via LATERAL JOIN. Evaluated metrics: Daily Study Hours, Sleep Hours, Previous Exam Score, Attendance Percentage.

5. Study Hours vs. Sleep Hours Interaction (02_impact_sleep_and_study_on_score.sql)
Categorized sleep and study hours into discrete ranges (0-2, 2-4, 4-6, 6-8, 8+ hours). Built a 2D cohort analysis to examine how sleep deprivation impacts study efficiency.

6. Preparation Days vs. Prior Academic Standing (03_prep_vs_previous_score.sql) Partitioned students into baseline score tiers (low, mid, high) using NTILE(3).Calculated linear regression slope (regr_slope) to measure points gained per preparation day for each tier.Key Insight: Evaluates whether low baseline students can close the achievement gap through extended preparation (22–30 days) versus high baseline students with minimal preparation (1–7 days).

7. Well-Being & Stress Factors (04_impact_of_wellbeing.sql & 05.impact-of-stress.sql)
Evaluated stress levels, exam anxiety, screen time, and physical activity across different exam difficulty tiers.Calculated point-biserial/linear correlations between physical activity, screen time, and exam performance under high-stress conditions.

8. Socioeconomic & Resource Inequity (06.social_inequity.sql)Grouped scores into 20-point brackets to evaluate demographic factors using mode statistical functions (MODE() WITHIN GROUP).Measured average internet access, online course hours, and private tuition correlation across achievement groups.

9. Student Growth & Progress Ranking (01.progress_ranking.sql)
Computed score change (delta = exam_score - previous_exam_score). Utilized window functions (PERCENT_RANK(), RANK(), AVG() OVER, STDDEV() OVER) to compute global and group-specific relative performance ranks. Z-score normalization for standardized growth comparison across education levels.

Data Stack & SQL Techniques Used
Database Engine: PostgreSQL
Analytical Concepts: Window Functions (PERCENT_RANK, RANK, NTILE, partitioned aggregates), Statistical Functions (CORR, regr_slope, MODE() WITHIN GROUP, PERCENTILE_CONT), Filtered Aggregations (AVG(...) FILTER (WHERE ...))Views & CTEs (CREATE VIEW, WITH clauses)Lateral Joins (CROSS JOIN LATERAL) for dynamically unpivoting metrics

