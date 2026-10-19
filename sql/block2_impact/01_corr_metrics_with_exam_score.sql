SELECT 
    t.col_name AS metric,
    ROUND(corr(t.val, exam_score)::numeric, 2) AS correlation
FROM public.student_exam_performance
CROSS JOIN LATERAL (
    VALUES 
        ('study', study_hours_per_day),
        ('sleep', sleep_hours),
        ('prev', previous_exam_score),
        ('attendance', attendance_percentage)
) AS t(col_name, val)
GROUP BY t.col_name;