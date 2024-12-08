-- loan purpose overview (count of each loan purpose) (gender-wise classification)
        WITH male_applicants AS (
									SELECT l.loan_purpose, COUNT(d.gender) AS male_applicants
									FROM demographic_info AS d
									JOIN loan_details AS l
									ON d.applicant_id = l.applicant_id
									WHERE d.gender = "Male"
									GROUP BY l.loan_purpose
								),
			female_applicants AS (
									SELECT l.loan_purpose, COUNT(d.gender) AS female_applicants
									FROM demographic_info AS d
									JOIN loan_details AS l
									ON d.applicant_id = l.applicant_id
									WHERE d.gender = "female"
									GROUP BY l.loan_purpose
								),  
			loan_purpose_aggregate AS (
									SELECT loan_purpose, COUNT(loan_purpose) AS Count_of_purpose_loan_borrowed
									FROM loan_details
									GROUP BY loan_purpose
									ORDER BY Count_of_purpose_loan_borrowed DESC
                                    )
			
            SELECT l.loan_purpose, m.male_applicants, f.female_applicants, l.Count_of_purpose_loan_borrowed AS total_applicants
            FROM loan_purpose_aggregate AS l
            JOIN male_applicants AS m
            ON l.loan_purpose = m.loan_purpose
            JOIN female_applicants AS f
            ON l.loan_purpose = f.loan_purpose;


-- Loan approval status by gender 
			SELECT d.gender, 
					COUNT(CASE WHEN l.loan_approval_status = 1 THEN 1 END) AS approved_loan,
					COUNT(CASE WHEN l.loan_approval_status = 0 THEN 1 END) AS denied_loan
			FROM demographic_info AS d
			JOIN loan_approval_status AS l
			ON d.applicant_id = l.applicant_id
			GROUP BY d.gender
			ORDER BY d.gender;
        
        
-- Loan Purpose Analysis with Terms and Interest Rates 
			SELECT loan_purpose, 
				   COUNT(loan_purpose) AS Count_of_purpose_loan_borrowed, 
				   ROUND(AVG(loan_term), 3) AS Average_terms_of_loan, 
				   ROUND(AVG(interest_rate), 3) AS Average_Rate_of_Interest
			FROM loan_details
			GROUP BY loan_purpose
			ORDER BY Count_of_purpose_loan_borrowed DESC; 

        
            
-- Average Financial Summary by Occupation
		SELECT d.occupation_type AS Occupation, 
			   ROUND(AVG(f.annual_income), 2) AS Avg_Annual_Income,
			   ROUND(AVG(f.monthly_expenses), 2) AS Avg_Monthly_Expense,
			   ROUND(AVG(f.total_existing_loan_amount), 2) AS Avg_Total_Existing_Loan_Amount,
			   ROUND(AVG(f.outstanding_debt), 2) AS Avg_Outstanding_Debt,
			   ROUND(AVG(l.loan_amount_requested), 2) AS Avg_Loan_Amount_Requested,
			   ROUND(AVG(l.transaction_frequency), 3) AS Avg_Transaction_Frequency
		FROM demographic_info AS d
		JOIN financial_info AS f 
        ON d.applicant_id = f.applicant_id
		JOIN loan_details AS l 
        ON d.applicant_id = l.applicant_id
		GROUP BY d.occupation_type
		ORDER BY Avg_Annual_Income DESC;
        
        
-- Residential Marital Status Summary
        SELECT residential_status,
				COUNT(CASE WHEN marital_status = 'Married' THEN 1 END) AS married_applicants,
				COUNT(CASE WHEN marital_status = 'Single' THEN 1 END) AS single_applicants,
				COUNT(CASE WHEN marital_status = 'Divorced' THEN 1 END) AS divorced_applicants,
                COUNT(residential_status) AS total_applicants
		FROM demographic_info
		GROUP BY residential_status
		ORDER BY total_applicants DESC;     

                
-- Marital status by Dependents Summary
        SELECT dependents,
				COUNT(CASE WHEN marital_status = 'Single' THEN 1 END) AS single_applicants,
                COUNT(CASE WHEN marital_status = 'Married' THEN 1 END) AS married_applicants,
				COUNT(CASE WHEN marital_status = 'Divorced' THEN 1 END) AS divorced_applicants,
                COUNT(dependents) AS total_applicants
		FROM demographic_info
		GROUP BY dependents
		ORDER BY dependents;
                
        
-- Loan type distributed by Occupation
		SELECT d.occupation_type AS Occupation, 
			   COUNT(CASE WHEN l.loan_type = 'Secured' THEN 1 END) AS secured_loan, 
			   COUNT(CASE WHEN l.loan_type = 'Unsecured' THEN 1 END) AS unsecured_applicants, 
			   COUNT(loan_purpose) AS total_applicants
		FROM demographic_info AS d 
		JOIN loan_details AS l
		ON d.applicant_id = l.applicant_id
		GROUP BY d.occupation_type
		ORDER BY total_applicants DESC;

        
-- Employment status distribution by Education
		SELECT education,
				COUNT(CASE WHEN employment_status = 'Employed' THEN 1 END) AS Employed,
				COUNT(CASE WHEN employment_status = 'Unemployed' THEN 1 END) AS Unemployed,
				COUNT(CASE WHEN employment_status = 'Self-employed' THEN 1 END) AS Self_employed,
                COUNT(education) AS total_applicants
		FROM demographic_info
		GROUP BY education
		ORDER BY education;

-- Co-applicant loandistribution by loan type 
		SELECT co_applicant,
				COUNT(CASE WHEN loan_type = 'Secured' THEN 1 END) AS secured_loan, 
				COUNT(CASE WHEN loan_type = 'Unsecured' THEN 1 END) AS unsecured_applicants, 
				COUNT(co_applicant) AS total_applicants
		FROM loan_details
		GROUP BY co_applicant;
		        