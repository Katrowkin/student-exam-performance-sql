SELECT 
    exam_difficulty AS difficulty,
	AVG(exam_score) AS score
FROM student_exam_performance AS perf
GROUP BY difficulty;