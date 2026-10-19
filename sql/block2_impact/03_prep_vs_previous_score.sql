CREATE SCHEMA IF NOT EXISTS analysis;

CREATE OR REPLACE VIEW analysis.v_prev_groups AS
SELECT
    t.student_id,
    t.previous_exam_score,
    t.exam_preparation_days,
    t.exam_score,
    t.prev_group,
    CASE t.prev_group
        WHEN 1 THEN 'low'
        WHEN 2 THEN 'mid'
        ELSE        'high'
    END AS prev_label,
    CASE
        WHEN t.exam_preparation_days <= 7  THEN '1: 1-7'
        WHEN t.exam_preparation_days <= 14 THEN '2: 8-14'
        WHEN t.exam_preparation_days <= 21 THEN '3: 15-21'
        ELSE                                    '4: 22-30'
    END AS prep_range
FROM (
    SELECT
        student_id,
        previous_exam_score,
        exam_preparation_days,
        exam_score,
        NTILE(3) OVER (ORDER BY previous_exam_score) AS prev_group
    FROM public.student_exam_performance
) t;

-- Which previous scores fall into "low", "mid", "high"?
SELECT
    prev_group,
    prev_label,
    COUNT(*)                  AS n,
    MIN(previous_exam_score)  AS min_prev,
    MAX(previous_exam_score)  AS max_prev
FROM analysis.v_prev_groups
GROUP BY prev_group, prev_label
ORDER BY prev_group;

-- Do weaker students prepare longer?
SELECT
    prev_group,
    prev_label,
    ROUND(AVG(exam_preparation_days)::numeric, 2) AS avg_prep_days,
    (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY exam_preparation_days))::numeric AS median_prep_days
FROM analysis.v_prev_groups
GROUP BY prev_group, prev_label
ORDER BY prev_group;

-- Average exam score by previous-score group and preparation range
SELECT
    prev_group,
    prev_label,
    ROUND(AVG(exam_score) FILTER (WHERE prep_range = '1: 1-7')::numeric,   1) AS prep_1_7,
    ROUND(AVG(exam_score) FILTER (WHERE prep_range = '2: 8-14')::numeric,  1) AS prep_8_14,
    ROUND(AVG(exam_score) FILTER (WHERE prep_range = '3: 15-21')::numeric, 1) AS prep_15_21,
    ROUND(AVG(exam_score) FILTER (WHERE prep_range = '4: 22-30')::numeric, 1) AS prep_22_30
FROM analysis.v_prev_groups
GROUP BY prev_group, prev_label
ORDER BY prev_group;

-- How many students are behind each number above?
SELECT
    prev_group,
    prev_label,
    COUNT(*) FILTER (WHERE prep_range = '1: 1-7')   AS n_1_7,
    COUNT(*) FILTER (WHERE prep_range = '2: 8-14')  AS n_8_14,
    COUNT(*) FILTER (WHERE prep_range = '3: 15-21') AS n_15_21,
    COUNT(*) FILTER (WHERE prep_range = '4: 22-30') AS n_22_30
FROM analysis.v_prev_groups
GROUP BY prev_group, prev_label
ORDER BY prev_group;

-- How many extra points does one more preparation day give in each group?
SELECT
    prev_group,
    prev_label,
    ROUND(regr_slope(exam_score, exam_preparation_days)::numeric, 3) AS points_per_day,
    ROUND(corr(exam_score, exam_preparation_days)::numeric, 3)       AS corr_prep_score
FROM analysis.v_prev_groups
GROUP BY prev_group, prev_label
ORDER BY prev_group;

-- Gain from long preparation (22-30 days) vs short (1-7 days), per group
SELECT
    prev_group,
    prev_label,
    ROUND(AVG(exam_score) FILTER (WHERE prep_range = '1: 1-7')::numeric,   1) AS avg_short_prep,
    ROUND(AVG(exam_score) FILTER (WHERE prep_range = '4: 22-30')::numeric, 1) AS avg_long_prep,
    ROUND((AVG(exam_score) FILTER (WHERE prep_range = '4: 22-30')
         - AVG(exam_score) FILTER (WHERE prep_range = '1: 1-7'))::numeric, 1) AS gain_from_prep
FROM analysis.v_prev_groups
GROUP BY prev_group, prev_label
ORDER BY prev_group;

-- Weak student with maximum preparation vs strong student with minimum preparation
WITH cell AS (
    SELECT
        prev_label,
        prep_range,
        AVG(exam_score) AS avg_score,
        COUNT(*)        AS n
    FROM analysis.v_prev_groups
    GROUP BY prev_label, prep_range
)
SELECT
    ROUND(l.avg_score::numeric, 1)                  AS low_prev_long_prep,
    ROUND(h.avg_score::numeric, 1)                  AS high_prev_short_prep,
    ROUND((l.avg_score - h.avg_score)::numeric, 1)  AS difference,
    l.n AS n_low_long,
    h.n AS n_high_short
FROM cell l
JOIN cell h
  ON l.prev_label = 'low'  AND l.prep_range = '4: 22-30'
 AND h.prev_label = 'high' AND h.prep_range = '1: 1-7';