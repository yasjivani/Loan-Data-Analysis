-- Statistical Analysis using various mathematical functions
-- Correlation between annual income and monthly expense     
		SELECT 
			ROUND(
					(COUNT(*) * SUM(annual_income * monthly_expenses) - SUM(annual_income) * SUM(monthly_expenses)) /
					(
						SQRT(
								(COUNT(*) * SUM(POW(annual_income, 2)) - SUM(annual_income) * SUM(annual_income)) *
								(COUNT(*) * SUM(POW(monthly_expenses, 2)) - SUM(monthly_expenses) * SUM(monthly_expenses))
							)
					)
			,2) AS correlation_coefficient_between_annual_income_and_credit_score
		FROM financial_info;


-- Correlation between annual income and loan amount requested 
		SELECT 
			ROUND(
					(COUNT(*) * SUM(f.annual_income * loan_amount_requested) - SUM(f.annual_income) * SUM(loan_amount_requested)) /
					(
						SQRT(
								(COUNT(*) * SUM(POW(f.annual_income, 2)) - SUM(f.annual_income) * SUM(f.annual_income)) *
								(COUNT(*) * SUM(POW(l.loan_amount_requested, 2)) - SUM(l.loan_amount_requested) * SUM(l.loan_amount_requested))
							)
					)
			,2) AS correlation_coefficient_between_annual_income_and_loan_amount_requested
		FROM financial_info AS f
		JOIN loan_details AS l 
		ON f.applicant_id = l.applicant_id;



-- Correlation between annual income and credit score
		SELECT 
			ROUND(
					(COUNT(*) * SUM(annual_income * credit_score) - SUM(annual_income) * SUM(credit_score)) /
					(
						SQRT(
								(COUNT(*) * SUM(POW(annual_income, 2)) - SUM(annual_income) * SUM(annual_income)) *
								(COUNT(*) * SUM(POW(credit_score, 2)) - SUM(credit_score) * SUM(credit_score))
							)
					)
			,2) AS correlation_coefficient_between_annual_income_and_credit_score
		FROM financial_info;
    
    


