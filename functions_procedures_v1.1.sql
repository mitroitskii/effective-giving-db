-- FUNCTIONS / PROCEDURES

USE effective_giving;


-- ** SELECT **

-- table: cause_area
	-- 1. get all causes
DROP PROCEDURE IF EXISTS get_causes;
DELIMITER $$
CREATE PROCEDURE get_causes()
	BEGIN
	SELECT cause_id AS "ID", cause_name AS "Causes" FROM cause_area;
	END$$
DELIMITER ;


-- table: intervention
	-- 1. get all interventions for a given cause

DROP PROCEDURE IF EXISTS get_intervention_for_cause;
DELIMITER $$
CREATE PROCEDURE get_intervention_for_cause(IN cause INT)
	BEGIN
	SELECT DISTINCT intervention_name FROM 
	(SELECT * FROM intervention
	LEFT JOIN problem 
    ON intervention.problem = problem.problem_id) AS T
	WHERE T.cause = cause;
	END$$
	DELIMITER ;
    
-- CALL get_intervention_for_cause(2);

	-- 2. get all interventions for a given problem

DROP PROCEDURE IF EXISTS get_intervention_for_problem;
DELIMITER $$
CREATE PROCEDURE get_intervention_for_problem(IN prob INT)
	BEGIN
	SELECT intervention_name FROM intervention
	WHERE problem = prob;
	END$$
	DELIMITER ;
    
-- CALL get_intervention_for_problem(2);
	
    -- 3. get all charities that have projects in a specific intervention
    
DROP PROCEDURE IF EXISTS get_charities_from_intervention;
DELIMITER $$
CREATE PROCEDURE get_charities_from_intervention(IN interv_ VARCHAR(128))
	BEGIN
	SELECT DISTINCT charity_id AS "id", charity_name AS "charity", charity_website AS "website", charity_description AS "description", charity_type AS
    "charity type" FROM project 
    LEFT JOIN charity
    ON project.charity = charity.charity_id
    WHERE intervention = interv_;
	END$$
	DELIMITER ;

-- CALL get_charities_from_intervention("Restorative surgery");


-- table: charity
	-- 1. get all charities for a given cause

DROP PROCEDURE IF EXISTS get_charities_from_cause;
DELIMITER $$
CREATE PROCEDURE get_charities_from_cause(IN id INT)
	BEGIN
    SELECT charity_id AS "id", charity_name AS "charity", charity_website AS "website", charity_description AS "description", charity_type AS
    "charity type" FROM
    charity
    WHERE charity_cause = id; 
	END$$
	DELIMITER ;
    
-- CALL get_charities_from_cause(1);

    -- 2. Get top charities for a given cause by a given evaluator in the latest year - USER END

DROP PROCEDURE IF EXISTS top_charities_cause_evaluator;
DELIMITER $$
CREATE PROCEDURE top_charities_cause_evaluator(IN cause_id INT, evaluator_id INT)
	BEGIN
	DECLARE year INT;
    SELECT MAX(evaluation_year) INTO year FROM evaluation;
    SELECT charity as "id", charity_name AS "charity", effectiveness_rank AS "rank", charity_website AS "website", charity_description AS "description", 
    charity_type AS "charity type" FROM
	(SELECT * FROM evaluation 
		LEFT JOIN charity -- evaluation x charity
        ON evaluation.charity = charity.charity_id
        WHERE (charity.charity_cause = cause_id AND evaluation_year = year AND evaluator = evaluator_id)
        ORDER BY effectiveness_rank DESC) AS T1; 
	END$$
	DELIMITER ;
	
-- CALL top_charities_cause_evaluator(2, 4);

	-- 3. Get a list of charities based on the first input letter

DROP PROCEDURE IF EXISTS get_charities_letter;
DELIMITER $$
CREATE PROCEDURE get_charities_letter(letter VARCHAR(8))
	BEGIN
	SELECT charity_id AS "id", charity_name AS "charity", charity_description AS "description",
    charity_website AS "website", charity_type AS "type" FROM charity WHERE left(charity_name, 1) = letter;
	END$$
	DELIMITER ;  
    
    -- 4. Get top charities by a given evaluator for the latest year

DROP PROCEDURE IF EXISTS top_charities_evaluator;
DELIMITER $$
CREATE PROCEDURE top_charities_evaluator(IN evaluator_id INT)
	BEGIN
    DECLARE year INT;
    SELECT MAX(evaluation_year) INTO year FROM evaluation;
    SELECT charity as "ID", charity_name AS "charity", effectiveness_rank AS "rank", charity_website AS "website", charity_description AS "description", 
    charity_type AS "charity type" FROM
	(SELECT * FROM evaluation 
		LEFT JOIN charity -- evaluation x charity
        ON evaluation.charity = charity.charity_id
        WHERE (evaluation_year = year AND evaluator = evaluator_id)
        ORDER BY effectiveness_rank DESC) AS T1; 
	END$$
	DELIMITER ;

-- CALL top_charities_evaluator(4);

	-- 5. Get charity types

DROP PROCEDURE IF EXISTS get_charity_types;
DELIMITER $$
CREATE PROCEDURE get_charity_types()
	BEGIN
	SELECT DISTINCT charity_type FROM charity;
	END$$
	DELIMITER ;



-- table: evaluator
	-- 1. Get evaluations by all evaluators of a given charity over time

DROP PROCEDURE IF EXISTS get_evaluations;
DELIMITER $$
CREATE PROCEDURE get_evaluations(IN charity_id INT)
	BEGIN
	SELECT charity_name AS "charity", evaluator_name AS "evaluator", evaluation_year AS "year", effectiveness_rank AS "rank" FROM evaluation 
    LEFT JOIN charity
    ON evaluation.charity = charity.charity_id
    LEFT JOIN evaluator
    ON evaluation.evaluator = evaluator.evaluator_id
    WHERE charity = charity_id
    ORDER BY evaluation_year;
	END$$
	DELIMITER ;
    
-- CALL get_evaluations(3);

	-- 2. Get a list of all the evaluators
DROP PROCEDURE IF EXISTS get_evaluator;
DELIMITER $$
CREATE PROCEDURE get_evaluator()
	BEGIN
	SELECT DISTINCT evaluator_id AS "ID", evaluator_name as "Evaluator", evaluator_website AS "Website" FROM evaluator;
	END$$
	DELIMITER ;

-- CALL get_evaluator();

-- table: donation
	-- 1. total donations for a charity 
DROP PROCEDURE IF EXISTS get_charity_donations;
DELIMITER $$
CREATE PROCEDURE get_charity_donations(IN charity_id INT)
	BEGIN
	SELECT charity_name as "charity", SUM(donation_amount) as "total donations" FROM 
    (SELECT * FROM donation
    LEFT JOIN charity 
    ON donation_charity = charity.charity_id
    WHERE donation_charity = charity_id) AS T
    GROUP BY donation_charity;
	END$$
	DELIMITER ;

-- CALL get_charity_donations(1);


-- table: project
	-- 1. all projects for a given charity

DROP PROCEDURE IF EXISTS get_charity_projects;
DELIMITER $$
CREATE PROCEDURE get_charity_projects(IN charity INT)
	BEGIN
	SELECT charity_name AS "charity", project_name AS "project", year_init AS "year started", project_status AS "project status" FROM project
    LEFT JOIN charity 
    ON project.charity = charity.charity_id
    WHERE charity_id = charity;
	END$$
	DELIMITER ;

-- CALL get_charity_projects(4);


-- table: source
	-- 1. get all sources

DROP PROCEDURE IF EXISTS get_sources;
DELIMITER $$
CREATE PROCEDURE get_sources()
	BEGIN
	SELECT source_id AS "ID", source_name AS "source" FROM source;
	END$$
	DELIMITER ;    

-- CALL get_sources();
    
-- table: country
	-- 1. get all countries

DROP PROCEDURE IF EXISTS get_countries;
DELIMITER $$
CREATE PROCEDURE get_countries()
	BEGIN
	SELECT country_id AS "ID", country_name AS "country" FROM country;
	END$$
	DELIMITER ;    
    
	-- 2. get all countries based on the first character

DROP PROCEDURE IF EXISTS get_countries_letter;
DELIMITER $$
CREATE PROCEDURE get_countries_letter(letter VARCHAR(8))
	BEGIN
	SELECT country_id AS "ID", country_name AS "country" FROM country WHERE left(country_name, 1) = letter;
	END$$
	DELIMITER ;    
    
    -- 3. get country from country_id

DROP PROCEDURE IF EXISTS get_country_from_id;
DELIMITER $$
CREATE PROCEDURE get_country_from_id(id INT)
	BEGIN
	SELECT country_name AS "country" FROM country WHERE left(country_name, 1) = country_id = id;
	END$$
	DELIMITER ;   


-- table: donor
	-- 1. get all donors

DROP PROCEDURE IF EXISTS get_donors;
DELIMITER $$
CREATE PROCEDURE get_donors()
	BEGIN
	SELECT * FROM donor;
	END $$
	DELIMITER ;    

	-- 2. get a specific donor
    
DROP PROCEDURE IF EXISTS get_specific_donor;
DELIMITER $$
CREATE PROCEDURE get_specific_donor(id INT)
	BEGIN
	SELECT first_name, last_name, email, country_name, source_name FROM donor 
    LEFT JOIN country
    ON donor_country = country_id
    LEFT JOIN source
    ON donor.source = source.source_id
    WHERE donor_id = id;
	END $$
	DELIMITER ;  

-- CALL get_specific_donor(1);

    -- 3. check if email already exists or not
DROP FUNCTION IF EXISTS check_email_uniqueness;
DELIMITER $$
CREATE FUNCTION check_email_uniqueness(email_id VARCHAR(128))
	RETURNS BOOLEAN DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE check_ BOOLEAN;
    IF EXISTS(SELECT email FROM donor WHERE email = email_id) THEN
		SET check_ = FALSE;
	ELSE SET check_ = TRUE;
    END IF;
    RETURN check_;
	END$$
	DELIMITER ;  
    
    -- 4. get donor_id from email
		-- takes two inputs: email and a variable to store the error value
        -- if email does not exist, it returns -1
    
DROP PROCEDURE IF EXISTS get_donorid;
DELIMITER $$
CREATE PROCEDURE get_donorid(IN email_id VARCHAR(128), OUT error_ INT)
	BEGIN
	IF NOT EXISTS (SELECT donor_id FROM donor WHERE email = email_id) THEN
		SET error_ = -1;
        SELECT @error_;
	ELSE SELECT donor_id FROM donor WHERE email = email_id;
    END IF;
	END $$
	DELIMITER ;  

-- CALL get_donorid("aa@email.com", @e);

-- table: problem
	-- 1. get all problems

DROP PROCEDURE IF EXISTS get_problems;
DELIMITER $$
CREATE PROCEDURE get_problems()
	BEGIN
	SELECT * FROM problem;
	END $$
	DELIMITER ;   
    
-- CALL get_problems();

    -- 2. get problem for a specific cause

DROP PROCEDURE IF EXISTS get_problem_for_cause;
DELIMITER $$
CREATE PROCEDURE get_problem_for_cause(causeID INT)
	BEGIN
	SELECT problem_id AS "ID", problem_name AS "problem" FROM problem
    WHERE cause = causeID;
	END $$
	DELIMITER ;   

-- CALL get_problem_for_cause(1);
    
-- table: income_rank
	-- 1. get the income ranking

DROP PROCEDURE IF EXISTS get_income_ranking;
DELIMITER $$
CREATE PROCEDURE get_income_ranking()
	BEGIN
	SELECT * FROM income_rank;
	END $$
	DELIMITER ;    
    

/* ------------------------- */

-- ** UPDATE **

-- table: donor
	-- 1. change donor details
		-- In this one, we'll have to ensure that null values are passed for those parameters that are not to be updated
		-- this will have to be configured in java
    
DROP PROCEDURE IF EXISTS update_donor;
DELIMITER $$
CREATE PROCEDURE update_donor(id INT, first VARCHAR(64), last VARCHAR(64), email_ VARCHAR(64), income DECIMAL(9, 2))
	BEGIN
	DECLARE rank_ DECIMAL(4, 2);
	IF (first IS NOT NULL) THEN -- first name
		UPDATE donor 
		SET first_name = first
		WHERE donor_id = id;
		END IF;
	IF (last IS NOT NULL) THEN -- last name
		UPDATE donor 
		SET last_name = first
		WHERE donor_id = id;
		END IF;
	IF (email_ IS NOT NULL) THEN -- email
		UPDATE donor 
		SET email = email_
		WHERE donor_id = id;
		END IF;
	IF (income IS NOT NULL) THEN -- email
		SET rank_ = get_income_rank(income);
		UPDATE donor 
		SET income_rank = rank_
		WHERE donor_id = id;
		END IF;
	END$$
	DELIMITER ;     
    
-- CALL update_donor(1, NULL, NULL, NULL, 3538.08); 


-- table: charity
	-- 1. update charity details
    -- Again, we'll have to ensure that null values are passed for those parameters that are not to be updated
		-- this will have to be configured in java

DROP PROCEDURE IF EXISTS update_charity;
DELIMITER $$
CREATE PROCEDURE update_charity(id INT, name VARCHAR(64), cause INT, description VARCHAR(64), type VARCHAR(64),
	country INT, link VARCHAR(64), website VARCHAR(64))
	BEGIN
	IF (name IS NOT NULL) THEN -- name
		UPDATE charity 
		SET charity_name = name
		WHERE charity_id = id;
		END IF;
	IF (cause IS NOT NULL) THEN -- cause
		UPDATE charity 
		SET charity_cause = cause
		WHERE charity_id = id;
		END IF;
	IF (description IS NOT NULL) THEN -- description
		UPDATE charity 
		SET charity_description = description
		WHERE charity_id = id;
		END IF;
	IF (type IS NOT NULL) THEN -- type
		UPDATE charity 
		SET charity_type = type
		WHERE charity_id = id;
		END IF;
	IF (country IS NOT NULL) THEN -- country
		UPDATE charity 
		SET charity_country = country
		WHERE charity_id = id;
		END IF;
	IF (link IS NOT NULL) THEN -- link
		UPDATE charity 
		SET donations_link = link
		WHERE charity_id = id;
		END IF;
	IF (website IS NOT NULL) THEN -- website
		UPDATE charity 
		SET charity_website = website
		WHERE charity_id = id;
		END IF;
	END$$
	DELIMITER ;     
    
-- CALL update_charity(1, NULL,NULL, NULL , 2, NULL, NULL, NULL);
    
-- table: cause_area
	-- 1. update cause

DROP PROCEDURE IF EXISTS update_cause;
DELIMITER $$
CREATE PROCEDURE update_cause(id INT, cause VARCHAR(64))
	BEGIN
	UPDATE cause_area
    SET cause_name = cause
    WHERE cause_id = id;
	END$$
	DELIMITER ;  

-- table: project 
	-- 1. update project status by taking charity's name as input

DROP PROCEDURE IF EXISTS update_project;
DELIMITER $$
CREATE PROCEDURE update_project(name VARCHAR(64), charity_name VARCHAR(64), interv VARCHAR(64), status VARCHAR(64))
	BEGIN
    DECLARE id INT;
    SET id = get_charity_id(charity_name); -- get the charity ID
	UPDATE project
    SET project_status = status
    WHERE (project_name = name AND intervention = interv AND charity = id);
	END$$
	DELIMITER ;  

-- CALL update_project("Cash Transfers in Africa", "GiveDirectly", "Cash transfers", "Active");
    
-- table: intervention 
	-- 1. update intervention
		-- plug in new intervention and problem names/ids and only change QALY if not null

DROP PROCEDURE IF EXISTS update_intervention;
DELIMITER $$
CREATE PROCEDURE update_intervention(old_name VARCHAR(64), new_name VARCHAR(64), old_prob INT, new_prob INT, qaly_ DECIMAL(4, 2))
	BEGIN
    -- check if new values don't exist already 
    IF (SELECT * FROM intervention WHERE intervention_name = new_name AND problem = new_prob) IS NULL THEN
		UPDATE intervention
		SET intervention_name = new_name, problem = new_prob
		WHERE (intervention_name = old_name AND problem = old_prob);
	END IF;
    -- update qaly if not null
    IF qaly_ IS NOT NULL THEN
		UPDATE intervention
		SET qaly = qaly_
		WHERE (intervention_name = new_name AND problem = new_prob);
	END IF;
	END$$
	DELIMITER ; 

    
-- table: evaluator 
	-- 1. update evaluator's website based on evaluator's name

DROP PROCEDURE IF EXISTS update_evaluator_website;
DELIMITER $$
CREATE PROCEDURE update_evaluator_website(name VARCHAR(128), website VARCHAR(128))
	BEGIN
    DECLARE id INT;
    SET id = get_evaluator_id(name); -- get the charity ID
	UPDATE EVALUATOR
    SET evaluator_website = website
    WHERE (evaluator_id = id);
	END$$
	DELIMITER ; 

-- CALL update_evaluator_website("GiveWell", "https://www.givewell.org/");

-- table: income_rank 
	-- 1. update percentile for a given income

DROP PROCEDURE IF EXISTS update_income_rank;
DELIMITER $$
CREATE PROCEDURE update_income_rank(income DECIMAL (9,2), perc DECIMAL(4,2))
	BEGIN
	UPDATE income_rank
    SET percentile = perc
    WHERE (annual_income = income);
	END$$
	DELIMITER ; 

-- table: problem
	-- 1. update problem
		-- take old problem and old cause and replace with new

DROP PROCEDURE IF EXISTS update_problem;
DELIMITER $$
CREATE PROCEDURE update_problem( old_prob VARCHAR(128), new_prob VARCHAR(128), old_cause INT, new_cause INT)
	BEGIN
    IF (SELECT problem_id FROM problem WHERE (problem_name = new_prob AND cause = new_cause)) IS NULL THEN
	UPDATE problem
    SET problem_name = new_prob, cause = new_cause
    WHERE (problem_name = old_prob AND cause = old_cause);
    END IF;
	END$$
	DELIMITER ; 

-- CALL update_problem("Factory Farming", "Factory Farming", 2, 1);



/* ------------------------- */

-- ** INSERT **

-- table: donor
	-- 1. insert new donor: 
		-- notes: takes country, actual source, actual income
        
DROP PROCEDURE IF EXISTS insert_donor;
DELIMITER $$
CREATE PROCEDURE insert_donor(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128), 
country INT, source_ INT, income DECIMAL(9,2))
	BEGIN
    DECLARE country_id INT;
    DECLARE source_id INT;
    DECLARE percentile DECIMAL(4, 2);
    SET country_id = country;
    SET source_id = source_;
    SET percentile = get_income_rank(income);
    INSERT INTO donor(first_name, last_name, email, donor_country, source, income_rank) 
    VALUES (first, last, mail, country_id, source_id, percentile);
	END$$
	DELIMITER ; 

-- CALL insert_donor("john", "smith", "jsmith@gmail.com", "Canada", "Word of mouth", 2404.08);

-- table: charity
	-- 1. insert new charity
		-- notes: takes actual cause name

DROP PROCEDURE IF EXISTS insert_charity;
DELIMITER $$
CREATE PROCEDURE insert_charity(name VARCHAR(128), website VARCHAR(128), description VARCHAR(128),  
type VARCHAR(128), cause INT,link VARCHAR(128))
	BEGIN
    INSERT INTO charity(charity_name, charity_website, charity_description, charity_type, charity_cause, donations_link) 
    VALUES (name, website, description, type, cause, link);
	END$$
	DELIMITER ; 
    
-- table: cause_area
	-- 1. insert new cause
		-- notes: takes actual

DROP PROCEDURE IF EXISTS insert_cause;
DELIMITER $$
CREATE PROCEDURE insert_cause(name VARCHAR(128))
	BEGIN
    -- check if cause already exists
    IF NOT EXISTS (SELECT * FROM cause_area WHERE cause_name = name) THEN
    INSERT INTO cause_area(cause_name) VALUES (name);
    END IF;
	END$$
	DELIMITER ; 
    
-- CALL insert_cause("Women's Rights");

-- table: donation - USER END
	-- 1. insert donation for a given charity
		-- notes: takes the name of the charity

DROP PROCEDURE IF EXISTS insert_donation;
DELIMITER $$
CREATE PROCEDURE insert_donation(id INT, charity VARCHAR(128), amount INT)
	BEGIN
    DECLARE charity_id INT;
    DECLARE date DATETIME;
    SET charity_id = get_charity_id(charity);
    SET date = NOW();
    INSERT INTO donation(donation_donor, donation_charity, donation_datetime, donation_amount) VALUES 
    (id, charity_id, date, amount);
	END$$
	DELIMITER ; 

-- table: evaluation
	-- 1. insert evaluation for a given charity by a given evaluator
		-- notes: takes actual values of charity and evaluator

DROP PROCEDURE IF EXISTS insert_evaluation;
DELIMITER $$
CREATE PROCEDURE insert_evaluation(evaluator VARCHAR(128), charity VARCHAR(128), year INT, rank_ INT)
	BEGIN
    DECLARE charity_id INT;
    DECLARE evaluator_id INT;
    SET charity_id = get_charity_id(charity);
	SET evaluator_id = get_evaluator_id(evaluator);
    INSERT INTO evaluation(evaluator, charity, evaluation_year, effectiveness_rank) VALUES 
    (evaluator_id, charity_id, year, rank_);
	END$$
	DELIMITER ; 
    
-- table: evaluator
	-- 1. insert evaluator

DROP PROCEDURE IF EXISTS insert_evaluator;
DELIMITER $$
CREATE PROCEDURE insert_evaluator(evaluator VARCHAR(128), website VARCHAR(128))
	BEGIN
    IF NOT EXISTS (SELECT * FROM evaluator WHERE evaluator_name = evaluator) THEN
    INSERT INTO evaluator(evaluator_name, evaluator_website) VALUES (evaluator, website);
    END IF;
	END$$
	DELIMITER ; 
    
-- table: problem
	-- 1. insert problem
		-- notes: takes actual value of cause

DROP PROCEDURE IF EXISTS insert_problem;
DELIMITER $$
CREATE PROCEDURE insert_problem(prob VARCHAR(128), cause_ INT)
	BEGIN
    IF NOT EXISTS (SELECT * FROM problem WHERE problem_name = prob) THEN -- if problem does not already exist, create one
		INSERT INTO problem(problem_name, cause) VALUES (prob, cause_);
    END IF;
	END$$
	DELIMITER ; 
    
    
-- table: intervention
	-- 1. insert intervention
		-- notes: takes actual values of problem

DROP PROCEDURE IF EXISTS insert_intervention;
DELIMITER $$
CREATE PROCEDURE insert_intervention(name VARCHAR(128), qaly_ DECIMAL(4,2), prob INT)
	BEGIN
    IF (SELECT * FROM intervention WHERE intervention_name = name AND problem = prob) IS NULL THEN -- check if intervention already exists
		INSERT INTO intervention(intervention_name, qaly, problem) VALUES (name, qaly_, prob);
    END IF;
	END$$
	DELIMITER ; 
    
-- table: project
	-- 1. insert project
		-- notes: takes actual values of problem

DROP PROCEDURE IF EXISTS insert_project;
DELIMITER $$
CREATE PROCEDURE insert_project(intervention_ VARCHAR(128), charity_ INT, name VARCHAR(128), year INT, status VARCHAR(128))
	BEGIN
    -- check if project doesn't already exists
    IF (SELECT * FROM project WHERE intervention = intervention_ AND charity = charity_ AND project_name = name) IS NULL THEN
    INSERT INTO project(intervention, charity, project_name, year_init, project_status)
    VALUES (intervention_, charity_, name, year, status);
    END IF;
	END$$
	DELIMITER ; 
    
-- table: source
	-- 1. insert source

DROP PROCEDURE IF EXISTS insert_source;
DELIMITER $$
CREATE PROCEDURE insert_source(source VARCHAR(128))
	BEGIN
    INSERT INTO source(source_name) VALUES (source);
	END$$
	DELIMITER ; 
    

/* ------------------------- */

-- ** DELETE **

-- table: charity

DROP PROCEDURE IF EXISTS delete_charity;
DELIMITER $$
CREATE PROCEDURE delete_charity(charity VARCHAR(128))
	BEGIN
    DELETE FROM charity WHERE charity_name = charity;
	END$$
	DELIMITER ; 

-- table: donor
	-- notes: delete donor based on donorID
DROP PROCEDURE IF EXISTS delete_donor;
DELIMITER $$
CREATE PROCEDURE delete_donor(donorID INT)
	BEGIN
    DELETE FROM donor WHERE donor_id = donorID;
	END$$
	DELIMITER ; 
    
-- table: intervention
	-- notes: delete intervention for a specific problem name
DROP PROCEDURE IF EXISTS delete_intervention;
DELIMITER $$
CREATE PROCEDURE delete_intervention(name VARCHAR(128), prob VARCHAR(128))
	BEGIN
    DECLARE prob_id INT;
    SET prob_id = get_prob_id(prob);
    DELETE FROM donor WHERE intervention_name = name AND problem = prob_id;
	END$$
	DELIMITER ; 
    
-- table: source
	
DROP PROCEDURE IF EXISTS delete_source;
DELIMITER $$
CREATE PROCEDURE delete_source(name VARCHAR(128))
	BEGIN
    DELETE FROM source WHERE source_name = name;
	END$$
	DELIMITER ; 

    
    
/* ------------------------- */

-- FUNCTIONS & PROCEDURES
    
-- table: income rank
	-- 1. get income rank based on income
DROP FUNCTION IF EXISTS get_income_rank; 
DELIMITER $$
CREATE FUNCTION get_income_rank(income DECIMAL(9,2))
	RETURNS DECIMAL(4, 2) DETERMINISTIC
	CONTAINS SQL
	BEGIN 
	DECLARE rank_ DECIMAL(4, 2) DEFAULT 0;
	DECLARE income_ DECIMAL(9, 2) DEFAULT 0;
	DECLARE counter INT DEFAULT 0;
	DECLARE total_ranks INT;
	DECLARE condition_ DECIMAL(9,2);
	SET total_ranks = (SELECT COUNT(*) FROM income_rank);
   
	WHILE counter < total_ranks DO
		SET condition_ = (SELECT annual_income FROM income_rank LIMIT counter, 1);
        IF  condition_ > income_ AND condition_ < income THEN
		SET income_ = (SELECT annual_income FROM income_rank LIMIT counter, 1);
		END IF;
        SET counter = counter + 1;
	END WHILE;
	SET rank_ = (SELECT percentile FROM income_rank WHERE annual_income = income_);
	RETURN(rank_); 
	END $$
   
   DELIMITER ; 
   
SELECT get_income_rank(500);


-- table: charity
    -- 1. get charity ID for a given charity name
    
DROP FUNCTION IF EXISTS get_charity_id;
DELIMITER $$
CREATE FUNCTION get_charity_id(name VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SELECT charity_id INTO id FROM charity
    WHERE charity_name = name; 
    RETURN id;
	END$$
	DELIMITER ;  
    
-- table: evaluator
    -- 1. get evaluator ID for a given evaluator name
    
DROP FUNCTION IF EXISTS get_evaluator_id;
DELIMITER $$
CREATE FUNCTION get_evaluator_id(name VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SELECT evaluator_id INTO id FROM evaluator
    WHERE evaluator_name = name; 
    RETURN id;
	END$$
	DELIMITER ;  

-- table: country
    -- 1. get country ID for a given country name
DROP FUNCTION IF EXISTS get_country_id;
DELIMITER $$
CREATE FUNCTION get_country_id(country VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SET id = NULL;
    SELECT country_id INTO id FROM country
    WHERE country_name = country; 
    RETURN id;
	END$$
	DELIMITER ; 
    
    
	-- 2. check if a country exists in the table or not
DROP FUNCTION IF EXISTS check_country_exists;
DELIMITER $$
CREATE FUNCTION check_country_exists(country VARCHAR(128))
	RETURNS BOOLEAN DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE check_ BOOLEAN;
    IF EXISTS(SELECT country_name FROM country WHERE country_name = country) THEN
		SET check_ = TRUE;
	ELSE SET check_ = FALSE;
    END IF;
    RETURN check_;
	END$$
	DELIMITER ; 
    
-- table: source
    -- 2. get source ID for a given source 
DROP FUNCTION IF EXISTS get_source_id;
DELIMITER $$
CREATE FUNCTION get_source_id(source VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SET id = NULL;
    SELECT source_id INTO id FROM source
    WHERE source_name = source; 
    RETURN id;
	END$$
	DELIMITER ;  
    
-- table: cause_area
    -- 2. get cause ID for a given cause 
DROP FUNCTION IF EXISTS get_cause_id;
DELIMITER $$
CREATE FUNCTION get_cause_id(cause VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SET id = NULL;
    SELECT cause_id INTO id FROM cause_area
    WHERE cause_name = cause; 
    RETURN id;
	END$$
	DELIMITER ;  

-- table: problem
    -- 2. get problem ID for a given cause 
DROP FUNCTION IF EXISTS get_problem_id;
DELIMITER $$
CREATE FUNCTION get_problem_id(prob VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SET id = NULL;
    SELECT problem_id INTO id FROM problem
    WHERE problem_name = prob; 
    RETURN id;
	END$$
	DELIMITER ;  
    


/* ------------------------- */

-- MY STATS -- DONOR

-- 1. My income ranking 
DROP PROCEDURE IF EXISTS my_income_rank;
DELIMITER $$
CREATE PROCEDURE my_income_rank(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128))
	BEGIN
    SELECT income_rank AS "income percentile" FROM donor WHERE (first_name = first AND last_name = last AND email = mail);
	END$$
	DELIMITER ; 
    
-- 2. a. My donations - total sum of donations 
DROP PROCEDURE IF EXISTS my_donations_sum;
DELIMITER $$
CREATE PROCEDURE my_donations_sum(donorID INT)
	BEGIN
    SELECT SUM(donation_amount) FROM donation
    WHERE donation_donor = donorID;
	END$$
	DELIMITER ; 

-- CALL my_donations_sum(2);

-- 2. b. My donations - total number of donations
DROP PROCEDURE IF EXISTS my_donations_count;
DELIMITER $$
CREATE PROCEDURE my_donations_count(donorID INT)
	BEGIN
    SELECT COUNT(donation_amount) FROM donation
    WHERE donation_donor = donorID;
	END$$
	DELIMITER ; 

-- CALL my_donations_count(2);

-- 2. c. My donations - causes I donated to 
DROP PROCEDURE IF EXISTS my_donations_causes;
DELIMITER $$
CREATE PROCEDURE my_donations_causes(donorID INT)
	BEGIN
    SELECT DISTINCT cause_name FROM donation
    LEFT JOIN charity
    ON donation_charity = charity_id
    LEFT JOIN cause_area
    ON charity.charity_cause = cause_area.cause_id
    WHERE donation_donor = donorID;
	END$$
	DELIMITER ; 

-- CALL my_donations_causes(2);

-- 2. d. My donations - all donations
DROP PROCEDURE IF EXISTS my_donations_all;
DELIMITER $$
CREATE PROCEDURE my_donations_all(donorID INT)
	BEGIN
    SELECT charity_name, cause_name, donation_datetime, donation_amount FROM donation
    LEFT JOIN charity
    ON donation_charity = charity_id
    LEFT JOIN cause_area
    ON charity.charity_cause = cause_area.cause_id
    WHERE donation_donor = donorID;
	END$$
	DELIMITER ; 

-- CALL my_donations_all(2);

-- 3. Avg donation by people in the same income rank

DROP PROCEDURE IF EXISTS average_donations_per_income_rank;
DELIMITER $$
CREATE PROCEDURE average_donations_per_income_rank(donorID INT)
	BEGIN
    DECLARE rank_ INT;
    SELECT income_rank INTO rank_ FROM donor WHERE (donor_id = donorID); -- get the donor rank
    SELECT AVG(donation_amount) AS "Average donation" FROM
    donation WHERE donation_donor IN (SELECT donor_id FROM donor WHERE income_rank = rank_)
    GROUP BY donation_donor;
	END$$
	DELIMITER ;


/* ------------------------- */

-- STATS -- ADMIN 

-- 1. Top 10 countries most donations come from

DROP PROCEDURE IF EXISTS top_donating_countries;
DELIMITER $$
CREATE PROCEDURE top_donating_countries()
	BEGIN
    SELECT country_name AS "country", SUM(donation_amount) AS "donations" FROM donation
    LEFT JOIN donor
    ON donation_donor = donor_id
    LEFT JOIN country
    ON donor.donor_country = country.country_id
    GROUP BY country_name
    ORDER BY SUM(donation_amount) DESC LIMIT 10;
    END$$
	DELIMITER ;
    
-- CALL top_donating_countries;

-- 2. Top 10 sources donors come from 

DROP PROCEDURE IF EXISTS top_ten_sources;
DELIMITER $$
CREATE PROCEDURE top_ten_sources()
	BEGIN
    SELECT source_name AS "source" FROM donor
    LEFT JOIN source
    ON source = source_id
    GROUP BY source_name
    ORDER BY COUNT(source_name) DESC LIMIT 10;
    END$$
	DELIMITER ;
    
-- CALL top_ten_sources;

-- 3. Top 10 charities with most donations 

DROP PROCEDURE IF EXISTS top_donated_charities;
DELIMITER $$
CREATE PROCEDURE top_donated_charities()
	BEGIN
	SELECT charity_name AS "Top donated charities" FROM donation
    LEFT JOIN charity
    ON donation_charity = charity_id
    GROUP BY charity_name
    ORDER BY SUM(donation_amount) DESC LIMIT 10;
    END$$
	DELIMITER ;

-- CALL top_donated_charities;


-- 3. Top 10 charities with least donations 

DROP PROCEDURE IF EXISTS least_donated_charities;
DELIMITER $$
CREATE PROCEDURE least_donated_charities()
	BEGIN
	SELECT charity_name AS "Least donated charities" FROM donation
    LEFT JOIN charity
    ON donation_charity = charity_id
    GROUP BY charity_name
    ORDER BY SUM(donation_amount) LIMIT 10;
    END$$
	DELIMITER ;

-- CALL least_donated_charities;

