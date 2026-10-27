WITH progress AS (
    SELECT
        student_id,
        education_level,
        previous_exam_score,
        exam_score,
        exam_score - previous_exam_score AS delta
    FROM student_exam_performance
),
ranked AS (
    SELECT *,
        PERCENT_RANK() OVER (ORDER BY delta) AS pr_global,
        PERCENT_RANK() OVER (PARTITION BY education_level ORDER BY delta) AS pr_in_group,
        RANK() OVER (PARTITION BY education_level ORDER BY delta DESC) AS rank_up,
        delta - AVG(delta) OVER (PARTITION BY education_level) AS delta_vs_group,
        (delta - AVG(delta) OVER ()) / NULLIF(STDDEV(delta) OVER (), 0) AS delta_z
    FROM progress
)
SELECT *,
    CASE
        WHEN pr_in_group >= 0.90 THEN 'Significant progress'
        WHEN pr_in_group <= 0.10 THEN 'Significant decrease'
        ELSE 'Stable'
    END AS progress_segment
FROM ranked
ORDER BY education_level, delta DESC
