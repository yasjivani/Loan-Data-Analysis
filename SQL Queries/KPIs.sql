-- Total number of Applicants (Total number of Loan Application) =30,000
		SELECT  COUNT(*) AS Total_Loan_Applications
		FROM demographic_info;
        
        
-- Classification of Applicants based on Gender
		SELECT gender,
			   COUNT(gender) AS Number_of_Applicants
		FROM demographic_info
		GROUP BY gender
		ORDER BY Number_of_Applicants;
    
    
-- Approval Rate and Rejection Rate
		SELECT ROUND(COUNT(CASE WHEN loan_approval_status = 1 THEN 1 END) * 100 / COUNT(*),2) AS Approval_Rate,
		ROUND(COUNT(CASE WHEN loan_approval_status = 0 THEN 1 END) * 100 / COUNT(*),2) AS Rejection_Rate
		FROM loan_approval_status;
		
    
-- Average Annual Income of Applicants
		SELECT d.occupation_type, 
		ROUND(AVG(f.annual_income),2) AS Average_Annual_Income
		FROM demographic_info AS d
		JOIN financial_info AS f
		ON d.applicant_id = f.applicant_id
		GROUP BY d.occupation_type
		ORDER BY Average_Annual_Income DESC;
    
    
-- Average Interst Rate
		SELECT ROUND(AVG(interest_rate),2) AS Average_ROI
		FROM loan_details;
    
    
-- DTI => Debt to Income Ratio
		SELECT applicant_id, 
			   ROUND((total_existing_loan_amount + outstanding_debt) * 100 / (annual_income) ,2) AS DTI_Ratio
		FROM financial_info;
    
-- Average DTI
		SELECT ROUND(AVG((total_existing_loan_amount + outstanding_debt) * 100 / (annual_income)),2) AS Avg_DTI
		FROM financial_info;
    
-- CLASSIFICATION AND ANALYSIS OF RISK (query written below is regard to this matter)

-- joint table of credit score, dti ratio, default risk 

		SELECT f.applicant_id, f.credit_score, l.default_risk
        FROM financial_info AS f        
        JOIN loan_approval_status AS l
        ON f.applicant_id = l.applicant_id;   
       
        
-- joint table of  degree and classification of risk based upon various facors such as credit score, dti ratio, default risk         
        WITH Risk_Anlaysis AS 
							(
								SELECT f.applicant_id, f.credit_score, l.default_risk
								FROM financial_info AS f        
								JOIN loan_approval_status AS l
								ON f.applicant_id = l.applicant_id        
							)
		
        SELECT applicant_id,
			   credit_score,
               CASE WHEN credit_score < 550 THEN "High Risk"
					WHEN credit_score > 550 AND credit_score < 700 THEN "Moderate Risk"
                    ELSE "Low Risk"
				END AS Degree_of_Risk_as_per_Credit_score,
                default_risk,
                CASE WHEN default_risk > 0.6 THEN "High Risk"
					 WHEN default_risk > 0.3 AND default_risk <= 0.6 THEN "Moderate Risk"
                     ELSE "Low Risk"
				END AS Degree_of_Risk_as_per_default_risk
		FROM Risk_Anlaysis; 
        
        
        
-- Determining overall risk based on degree of risk based upon various factors 
		WITH Overall_risk AS 
							(
							 WITH Risk_Anlaysis AS 
											(
												SELECT f.applicant_id, f.credit_score, l.default_risk
												FROM financial_info AS f        
												JOIN loan_approval_status AS l
												ON f.applicant_id = l.applicant_id							
											)
	
							SELECT applicant_id,
								   credit_score,
								   CASE WHEN credit_score < 550 THEN "High Risk"
										WHEN credit_score > 550 AND credit_score < 700 THEN "Moderate Risk"
										ELSE "Low Risk"
									END AS Degree_of_Risk_as_per_Credit_score,
									default_risk,
									CASE WHEN default_risk > 0.6 THEN "High Risk"
										 WHEN default_risk > 0.3 AND default_risk <= 0.6 THEN "Moderate Risk"
										 ELSE "Low Risk"
									END AS Degree_of_Risk_as_per_default_risk
							FROM Risk_Anlaysis                             
							)
			SELECT applicant_id,
				   Degree_of_Risk_as_per_Credit_score,					   
				   Degree_of_Risk_as_per_default_risk,
				   CASE 
					   WHEN (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
							OR (Degree_of_Risk_as_per_Credit_score = 'Moderate Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
							OR (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'Moderate Risk') 
					   THEN 'High risk Level'
					   WHEN (Degree_of_Risk_as_per_Credit_score = 'Low Risk' AND Degree_of_Risk_as_per_default_risk = 'Low Risk')
					   THEN 'Low risk Level'
					   ELSE 'Moderate risk Level'
				   END AS Overall_degree_of_risk
			FROM Overall_risk;        
    
    
-- 3 level categorization of overall risk 
			WITH Count_of_Risk AS (
									WITH Overall_risk AS 
									(
									 WITH Risk_Anlaysis AS 
													(
														SELECT f.applicant_id, f.credit_score, l.default_risk
														FROM financial_info AS f        
														JOIN loan_approval_status AS l
														ON f.applicant_id = l.applicant_id							
													)
			
									SELECT applicant_id,
										   credit_score,
										   CASE WHEN credit_score < 550 THEN "High Risk"
												WHEN credit_score > 550 AND credit_score < 700 THEN "Moderate Risk"
												ELSE "Low Risk"
											END AS Degree_of_Risk_as_per_Credit_score,
											default_risk,
											CASE WHEN default_risk > 0.6 THEN "High Risk"
												 WHEN default_risk > 0.3 AND default_risk <= 0.6 THEN "Moderate Risk"
												 ELSE "Low Risk"
											END AS Degree_of_Risk_as_per_default_risk
									FROM Risk_Anlaysis                             
									)
									SELECT applicant_id,
										   Degree_of_Risk_as_per_Credit_score,					   
										   Degree_of_Risk_as_per_default_risk,
										   CASE 
											   WHEN (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
													OR (Degree_of_Risk_as_per_Credit_score = 'Moderate Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
													OR (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'Moderate Risk') 
											   THEN 'High risk Level'
											   WHEN (Degree_of_Risk_as_per_Credit_score = 'Low Risk' AND Degree_of_Risk_as_per_default_risk = 'Low Risk')
											   THEN 'Low risk Level'
											   ELSE 'Moderate risk Level'
										   END AS Overall_degree_of_risk
									FROM Overall_risk
									)
									
				SELECT Overall_degree_of_risk,
					   COUNT(*) AS No_of_Applicants
				FROM Count_of_Risk
				GROUP BY Overall_degree_of_risk;
                
                     
                     
-- GOOD V BAD LOAN		
       WITH Good_v_Bad_loan AS (
							WITH Overall_risk AS 
												(
												 WITH Risk_Anlaysis AS 
																(
																	SELECT f.applicant_id, f.credit_score, l.default_risk
																	FROM financial_info AS f        
																	JOIN loan_approval_status AS l
																	ON f.applicant_id = l.applicant_id							
																)
						
												SELECT applicant_id,
													   credit_score,
													   CASE WHEN credit_score < 550 THEN "High Risk"
															WHEN credit_score > 550 AND credit_score < 700 THEN "Moderate Risk"
															ELSE "Low Risk"
														END AS Degree_of_Risk_as_per_Credit_score,
														default_risk,
														CASE WHEN default_risk > 0.6 THEN "High Risk"
															 WHEN default_risk > 0.3 AND default_risk <= 0.6 THEN "Moderate Risk"
															 ELSE "Low Risk"
														END AS Degree_of_Risk_as_per_default_risk
												FROM Risk_Anlaysis                             
												)
									SELECT applicant_id,
										   Degree_of_Risk_as_per_Credit_score,					   
										   Degree_of_Risk_as_per_default_risk,
										   CASE 
											   WHEN (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
													OR (Degree_of_Risk_as_per_Credit_score = 'Moderate Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
													OR (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'Moderate Risk') 
											   THEN 'High risk Level'
											   WHEN (Degree_of_Risk_as_per_Credit_score = 'Low Risk' AND Degree_of_Risk_as_per_default_risk = 'Low Risk')
											   THEN 'Low risk Level'
											   ELSE 'Moderate risk Level'
										   END AS Overall_degree_of_risk
								FROM Overall_risk
							)	
		SELECT 
        -- Good loan ( CTE used "Good_v_Bad_loan")
        COUNT(CASE WHEN Overall_degree_of_risk IN ('Low risk Level', 'Moderate risk Level') THEN 1 END) AS Good_Loans_Count,
		ROUND((COUNT(CASE WHEN Overall_degree_of_risk IN ('Low risk Level', 'Moderate risk Level') THEN 1 END) / COUNT(*)) * 100,2) AS Percentage_of_Good_Loans,
        -- Bad loan ( CTE used "Good_v_Bad_loan")
        COUNT(CASE WHEN Overall_degree_of_risk ='High risk Level' THEN 1 END) AS Bad_Loans_Count,
		ROUND((COUNT(CASE WHEN Overall_degree_of_risk ='High risk Level' THEN 1 END) / COUNT(*)) * 100,2) AS Percentage_of_Bad_Loans
		FROM Good_v_Bad_loan;
       
  
-- Type of Loan distributed by Address stae (highest good loans & highest bad loans) 
		WITH address_and_loan_type AS (
									   WITH Good_v_Bad_loan AS (
																WITH Overall_risk AS 
																					(
																					 WITH Risk_Anlaysis AS 
																										(
																											SELECT f.applicant_id, f.credit_score, l.default_risk
																											FROM financial_info AS f        
																											JOIN loan_approval_status AS l
																											ON f.applicant_id = l.applicant_id							
																										)
						
																						SELECT applicant_id,
																							   credit_score,
																							   CASE WHEN credit_score < 550 THEN "High Risk"
																									WHEN credit_score > 550 AND credit_score < 700 THEN "Moderate Risk"
																									ELSE "Low Risk"
																								END AS Degree_of_Risk_as_per_Credit_score,
																								default_risk,
																								CASE WHEN default_risk > 0.6 THEN "High Risk"
																									 WHEN default_risk > 0.3 AND default_risk <= 0.6 THEN "Moderate Risk"
																									 ELSE "Low Risk"
																								END AS Degree_of_Risk_as_per_default_risk
																						FROM Risk_Anlaysis                             
																						)
																		SELECT applicant_id,
																			   Degree_of_Risk_as_per_Credit_score,					   
																			   Degree_of_Risk_as_per_default_risk,
																			   CASE 
																				   WHEN (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
																						OR (Degree_of_Risk_as_per_Credit_score = 'Moderate Risk' AND Degree_of_Risk_as_per_default_risk = 'High Risk')
																						OR (Degree_of_Risk_as_per_Credit_score = 'High Risk' AND Degree_of_Risk_as_per_default_risk = 'Moderate Risk') 
																				   THEN 'High risk Level'
																				   WHEN (Degree_of_Risk_as_per_Credit_score = 'Low Risk' AND Degree_of_Risk_as_per_default_risk = 'Low Risk')
																				   THEN 'Low risk Level'
																				   ELSE 'Moderate risk Level'
																			   END AS Overall_degree_of_risk
																	FROM Overall_risk
																)
																					
										SELECT d.applicant_id,d.address_state,
										CASE WHEN g.Overall_degree_of_risk IN ('Low risk Level', 'Moderate risk Level') THEN "Good Loan" ELSE "Bad Loan" END AS Good_V_Bad_Loans
										FROM demographic_info AS d
										JOIN Good_v_Bad_loan AS g
										ON d.applicant_id = g.applicant_id
                                        )
			            
			SELECT address_state,
            COUNT(CASE WHEN Good_V_Bad_Loans = 'Good Loan' THEN 1 END) AS Good_loan,
			COUNT(CASE WHEN Good_V_Bad_Loans = 'Bad Loan' THEN 1 END) AS Bad_loan,
            COUNT(address_state) AS total_applicants,
            ROUND(COUNT(CASE WHEN Good_V_Bad_Loans = 'Good Loan' THEN 1 END)*100/COUNT(address_state),2) AS percentage_of_good_loan
            FROM  address_and_loan_type 
            GROUP BY address_state
            ORDER BY percentage_of_good_loan DESC
            LIMIT 5;
            
			-- use  "address_and_loan_type" CTE to run this Query
			SELECT address_state,
            COUNT(CASE WHEN Good_V_Bad_Loans = 'Good Loan' THEN 1 END) AS Good_loan,
			COUNT(CASE WHEN Good_V_Bad_Loans = 'Bad Loan' THEN 1 END) AS Bad_loan,
            COUNT(address_state) AS total_applicants,
            ROUND(COUNT(CASE WHEN Good_V_Bad_Loans = 'Bad Loan' THEN 1 END)*100/COUNT(address_state),2) AS percentage_of_bad_loan
            FROM  address_and_loan_type 
            GROUP BY address_state
            ORDER BY percentage_of_bad_loan DESC
            LIMIT 3;
            
            