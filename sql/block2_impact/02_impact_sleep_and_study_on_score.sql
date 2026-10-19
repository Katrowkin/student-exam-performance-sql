SELECT CASE 
        WHEN sleep_hours < 2 THEN '1: 0-2'
        WHEN sleep_hours < 4 THEN '2: 2-4'
        WHEN sleep_hours < 6 THEN '3: 4-6'
        WHEN sleep_hours < 8 THEN '4: 6-8'
        ELSE '5: 8+'
    END AS sleep_pnight,

		CASE
         WHEN study_hours_per_day < 2 THEN '1: 0-2'
         WHEN study_hours_per_day < 4 THEN '2: 2-4'
         WHEN study_hours_per_day < 6 THEN '3: 4-6'
         WHEN study_hours_per_day < 8 THEN '4: 6-8'
         ELSE '5: 8+'
       END AS hours_pday,
       COUNT(*) AS n_students,
       ROUND(AVG(exam_score),1) AS avg_score
FROM public.student_exam_performance
GROUP BY 1, 2
ORDER BY 1, 2;