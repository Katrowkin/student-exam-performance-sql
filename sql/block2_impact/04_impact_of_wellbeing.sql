WITH aggregated_stats AS (
    SELECT 
       exam_difficulty,
	ROUND(AVG(stress_level),2) AS stress_lvl,
	ROUND(AVG(exam_anxiety_level),2) AS anxiety_lvl,
	ROUND(AVG(daily_screen_time),2) AS screen_time,
	ROUND(AVG(student_exam_performance.physical_activity_hours),2) AS phys_activity,
	ROUND(AVG(exam_score),2) AS score
    FROM public.student_exam_performance
    GROUP BY exam_difficulty
)
SELECT 
    exam_difficulty,
  	stress_lvl,
    anxiety_lvl,
    screen_time,
    phys_activity,
    score
FROM aggregated_stats
ORDER BY score DESC;