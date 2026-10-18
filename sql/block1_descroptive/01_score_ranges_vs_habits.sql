SELECT 
    CONCAT(
        CAST(FLOOR((exam_score - 0.01) / 10) * 10 + 1 AS INT), 
        '-', 
        CAST(FLOOR((exam_score - 0.01) / 10) * 10 + 10 AS INT)
    ) AS score_range,
    COUNT(student_id) AS total_students,
    ROUND(AVG(study_hours_per_day), 2) AS avg_study_day,
    ROUND(AVG(daily_screen_time), 2) AS screen_time,
    ROUND(AVG(sleep_hours), 2) AS sleep
FROM student_exam_performance AS perf
GROUP BY FLOOR((exam_score - 0.01) / 10)
ORDER BY FLOOR((exam_score - 0.01) / 10);