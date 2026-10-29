SELECT 
    CASE
        WHEN exam_score < 20 THEN '0-20'
        WHEN exam_score < 40 THEN '20-40'
        WHEN exam_score < 60 THEN '40-60'
        WHEN exam_score < 80 THEN '60-80'
        WHEN exam_score <= 100 THEN '80-100'
    END AS exam_score_category,
    COUNT(student_id) AS student_count,
    MODE() WITHIN GROUP (ORDER BY family_income) AS most_common_family_income,
    MODE() WITHIN GROUP (ORDER BY parent_education) AS most_common_parent_education,
    MODE() WITHIN GROUP (ORDER BY urban_rural) AS most_common_urban_rural,
	ROUND(AVG(internet_access), 2) AS avg_internet_access,
	ROUND(AVG(online_course_hours), 2) AS avg_online_course_hrs,
	ROUND(CORR(private_tuition, exam_score)::numeric, 2) AS corr_private_tuition
FROM public.student_exam_performance
GROUP BY 
    CASE
        WHEN exam_score < 20 THEN '0-20'
        WHEN exam_score < 40 THEN '20-40'
        WHEN exam_score < 60 THEN '40-60'
        WHEN exam_score < 80 THEN '60-80'
        WHEN exam_score <= 100 THEN '80-100'
    END
