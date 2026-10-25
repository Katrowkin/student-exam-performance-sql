SELECT 
	exam_difficulty,
	ROUND(AVG(exam_score), 2) AS score,
	ROUND(AVG(stress_level), 2) AS stress,
	ROUND(CORR(daily_screen_time, exam_score)::numeric, 2) AS screen_time_on_score,
	ROUND(AVG(exam_anxiety_level), 2) AS exam_anxiety,
	ROUND(CORR(physical_activity_hours, exam_score)::numeric, 2) AS phys_act_on_score
FROM public.student_exam_performance AS s1
GROUP BY exam_difficulty
ORDER BY score DESC