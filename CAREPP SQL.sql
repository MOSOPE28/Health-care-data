COPY "CAREPP"
FROM 'C:\Program Files\PostgreSQL\16\data\COPY DATA\CAREPP.csv'CSV HEADER

SELECT *
FROM "CAREPP"

--WHAT IS THE DEMOGRAPHIC DISTRIBUTION OF PATIENT BASED ON AGE AND GENDER
SELECT 
    "AGE",
    "GENDER",
    COUNT(*) AS patient_count
FROM 
    "CAREPP"
GROUP BY 
    "AGE", 
    "GENDER"
ORDER BY 
    "AGE", 
    "GENDER";

---WHAT IS THE DEMOGRAPHIC DISTRIBUTION OF PATIENT BASED ON AGE AND GENDER CATEGORIZING AGES INTO AGE GROUP 
SELECT
    CASE
        WHEN "AGE" BETWEEN 0 AND 10 THEN '0-10'
        WHEN "AGE" BETWEEN 11 AND 20 THEN '11-20'
        WHEN "AGE" BETWEEN 21 AND 30 THEN '21-30'
        WHEN "AGE" BETWEEN 31 AND 40 THEN '31-40'
        WHEN "AGE" BETWEEN 41 AND 50 THEN '41-50'
        WHEN "AGE" BETWEEN 51 AND 60 THEN '51-60'
        WHEN "AGE" BETWEEN 61 AND 70 THEN '61-70'
        WHEN "AGE" BETWEEN 71 AND 80 THEN '71-80'
        ELSE '81+'
    END AS age_group,
    "GENDER",
    COUNT(*) AS patient_count
FROM 
    "CAREPP"
GROUP BY 
    age_group, 
    "GENDER"
ORDER BY 
    age_group, 
    "GENDER";

-- WHAT BLOOD TYPE IS MOST COMMON AMONG PATIENTS FROM THE HIHEST TO THE LOWEST
SELECT "BLOOD_TYPE", COUNT(*) AS count
FROM "CAREPP"
GROUP BY "BLOOD_TYPE"
ORDER BY count DESC;

--WHAT ARE THE MOST PREVELANT MEDICAL CONDITION AMONG PATIENTS?
 
FROM patient_conditions
GROUP BY condition
ORDER BY count DESC;

-- IS THERE ANY CORRELATION BETWEEN AGE AND MEDICAL CONDITION?
SELECT
    CASE
        WHEN "AGE" BETWEEN 0 AND 10 THEN '0-10'
        WHEN "AGE" BETWEEN 11 AND 20 THEN '11-20'
        WHEN "AGE" BETWEEN 21 AND 30 THEN '21-30'
        WHEN "AGE" BETWEEN 31 AND 40 THEN '31-40'
        WHEN "AGE" BETWEEN 41 AND 50 THEN '41-50'
        WHEN "AGE" BETWEEN 51 AND 60 THEN '51-60'
        WHEN "AGE" BETWEEN 61 AND 70 THEN '61-70'
        WHEN "AGE" BETWEEN 71 AND 80 THEN '71-80'
        ELSE '81+'
    END AS age_group,
    "MEDICAL_CONDITION",
    COUNT(*) AS number_of_cases
FROM "CAREPP"
GROUP BY age_group,"MEDICAL_CONDITION"
ORDER BY age_group, "MEDICAL_CONDITION";

-- How does the distribution of patients vary across hospitals?
SELECT "HOSPITAL", COUNT(*) AS number_of_patients
FROM "CAREPP"
GROUP BY "HOSPITAL"
ORDER BY number_of_patients DESC;


-- WHICH DOCTOR TREATS THE HIGHEST NUMBER OF PATIENTS?
SELECT 
    "DOCTOR",
    COUNT(*) AS patient_count
FROM 
    "CAREPP"
GROUP BY 
    "DOCTOR"
ORDER BY 
    patient_count DESC
LIMIT 20;

-- What is the average billing amount for different medical conditions?
SELECT 
    "MEDICAL_CONDITION",
    ROUND(AVG("BILLING_AMOUNT"), 0) AS average_billing_amount
FROM 
    "CAREPP"
GROUP BY 
    "MEDICAL_CONDITION";
----ALTERNATIVE FORM
SELECT 
    "MEDICAL_CONDITION",
    AVG(CAST(COALESCE("BILLING_AMOUNT", 0) AS FLOAT)) AS average_billing_amount
FROM 
    "CAREPP"
GROUP BY 
    "MEDICAL_CONDITION";
				   
---- Which insurance provider is most commonly used by patients?				   
SELECT 
    "INSURANCE_PROVIDER",
    COUNT(*) AS patient_count
FROM 
    "CAREPP"
WHERE 
    "INSURANCE_PROVIDER" IS NOT NULL
GROUP BY 
    "INSURANCE_PROVIDER"
ORDER BY 
    patient_count DESC

---What is the average length of stay for patients?	
SELECT 
    AVG(AGE("DISCHARGE_DATE","DATE_OF_ADMISSION")) AS avg_length_of_stay
FROM 
    "CAREPP"
WHERE 
    "DISCHARGE_DATE" IS NOT NULL AND "DATE_OF_ADMISSION" IS NOT NULL;

---- How many patients were admitted for each admission type (e.g., emergency, elective)?
SELECT 
    "ADMISSION_TYPE", 
    COUNT(*) AS patient_count
FROM 
    "CAREPP"
GROUP BY 
    "ADMISSION_TYPE"
ORDER BY 
    patient_count DESC;
	
----What is the distribution of discharge dates?
SELECT 
    "DISCHARGE_DATE", 
    COUNT(*) AS discharge_count
FROM 
    "CAREPP"
GROUP BY 
    "DISCHARGE_DATE"
ORDER BY 
    "DISCHARGE_DATE";

---Which medications are most frequently prescribed to patients?
SELECT 
    "MEDICATION", 
    COUNT(*) AS prescription_count
FROM 
    "CAREPP"
GROUP BY 
    "MEDICATION"
ORDER BY 
    prescription_count DESC;

----Are there any common patterns in test results for patients with similar medical conditions?
SELECT 
    "MEDICAL_CONDITION",
    "TEST_RESULTS",
    COUNT(*) AS result_count
FROM 
    "CAREPP"
GROUP BY 
  "MEDICAL_CONDITION","TEST_RESULTS"
ORDER BY 
  "MEDICAL_CONDITION" , result_count DESC;

---What is the average age of patients admitted to each hospital?
SELECT 
    "HOSPITAL",
    ROUND(AVG("AGE"),0) AS average_age
	    
FROM 
    "CAREPP"
GROUP BY 
    "HOSPITAL"
ORDER BY 
    average_age DESC;

---How does the billing amount vary based on gender?
SELECT 
    "GENDER",
    ROUND(AVG("BILLING_AMOUNT"),0) AS avg_billing_amount,
    MIN("BILLING_AMOUNT") AS min_billing_amount,
    MAX("BILLING_AMOUNT") AS max_billing_amount,
    SUM("BILLING_AMOUNT") AS total_billing_amount,
    COUNT(*) AS number_of_patients
FROM 
    "CAREPP"
GROUP BY 
    "GENDER"
ORDER BY 
    "GENDER";

---Are there any seasonal trends in patient admissions?
SELECT
    EXTRACT(MONTH FROM "DATE_OF_ADMISSION") AS month,
    COUNT(*) AS number_of_admissions
FROM
    "CAREPP"
GROUP BY
    EXTRACT(MONTH FROM "DATE_OF_ADMISSION")
ORDER BY
    month;

	
SELECT
    EXTRACT(YEAR FROM "DATE_OF_ADMISSION" ) AS year,
    EXTRACT(MONTH FROM "DATE_OF_ADMISSION") AS month,
    COUNT(*) AS number_of_admissions
FROM
    "CAREPP"
GROUP BY
    EXTRACT(YEAR FROM "DATE_OF_ADMISSION"),
    EXTRACT(MONTH FROM "DATE_OF_ADMISSION")
ORDER BY
    year, month;
	
---- Which medical conditions have the highest billing amounts?
SELECT
    "MEDICAL_CONDITION",
    SUM("BILLING_AMOUNT") AS total_billing_amount
FROM
    "CAREPP"
GROUP BY
    "MEDICAL_CONDITION"
ORDER BY
    total_billing_amount DESC;

-----Is there a difference in the distribution of patients based on age and gender across different hospitals?
SELECT
   "HOSPITAL",
    "GENDER",
    age_group,
    COUNT(*) AS patient_count
FROM (
    SELECT
        "HOSPITAL",
        "GENDER",
        CASE
            WHEN "AGE" BETWEEN 0 AND 10 THEN '0-10'
            WHEN "AGE" BETWEEN 11 AND 20 THEN '11-20'
            WHEN "AGE" BETWEEN 21 AND 30 THEN '21-30'
            WHEN "AGE" BETWEEN 31 AND 40 THEN '31-40'
            WHEN "AGE" BETWEEN 41 AND 50 THEN '41-50'
            WHEN "AGE"BETWEEN 51 AND 60 THEN '51-60'
            WHEN "AGE" BETWEEN 61 AND 70 THEN '61-70'
            WHEN "AGE" BETWEEN 71 AND 80 THEN '71-80'
            WHEN "AGE" > 80 THEN '>80'
            ELSE 'Unknown'
        END AS age_group
    FROM
        "CAREPP"
) AS age_gender_distribution
GROUP BY
    "HOSPITAL",
    "GENDER",
    age_group
ORDER BY
    "HOSPITAL",
    "GENDER",
    age_group;
