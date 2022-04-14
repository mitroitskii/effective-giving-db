-- FUNCTIONS / PROCEDURES

USE effective_giving;

-- ** SELECT **

-- table: cause_area
	-- 1. get all causes
DROP PROCEDURE IF EXISTS get_causes;
DELIMITER $$
CREATE PROCEDURE get_causes()
	BEGIN
	SELECT cause_name AS "Causes" FROM cause_area;
	END$$
DELIMITER ;

-- CALL get_causes();

-- table: intervention
	-- 1. get all interventions for a given cause

DROP PROCEDURE IF EXISTS get_intervention;
DELIMITER $$
CREATE PROCEDURE get_intervention(IN cause VARCHAR(128))
	BEGIN
	SELECT DISTINCT intervention_name FROM 
	(SELECT * FROM intervention
	LEFT JOIN problem 
    ON intervention.problem = problem.problem_id
    LEFT JOIN cause_area
    ON problem.cause = cause_area.cause_id) AS new
	WHERE cause_name = cause;
	END$$
	DELIMITER ;

-- CALL get_intervention("Global Health and Development");

-- table: charity
	-- 1. get all charities for a given cause

DROP PROCEDURE IF EXISTS get_charity;
DELIMITER $$
CREATE PROCEDURE get_charity(IN cause VARCHAR(128))
	BEGIN
    SELECT charity_name AS "charity", charity_website AS "website", charity_description AS "description", charity_type AS
    "charity type" FROM
    (SELECT * FROM
    charity
    LEFT JOIN cause_area  -- charity x cause_area
    ON charity.charity_cause = cause_area.cause_id
    WHERE cause_name = cause) AS T1; 
	END$$
	DELIMITER ;

    
-- CALL get_charity("Global Health and Development");

    -- 2. Get top 10 charities for a given cause - USER END

DROP PROCEDURE IF EXISTS top_ten_charities;
DELIMITER $$
CREATE PROCEDURE top_ten_charities(IN cause VARCHAR(128), IN year INT)
	BEGIN
    SELECT charity_name AS "charity", effectiveness_rank AS "rank", charity_website AS "website", charity_description AS "description", 
    charity_type AS "charity type" FROM
	(SELECT * FROM evaluation 
		LEFT JOIN charity -- evaluation x charity
        ON evaluation.charity = charity.charity_id
		LEFT JOIN cause_area  -- charity x cause_area
		ON charity.charity_cause = cause_area.cause_id 
        WHERE (cause_name = cause AND evaluation_year = year)
        ORDER BY effectiveness_rank DESC) AS T1; 
	END$$
	DELIMITER ;

-- CALL top_ten_charities("Global Health and Development", 2021);
    
-- table: evaluator
	-- 1. Get evaluations of a given charity over time

DROP PROCEDURE IF EXISTS get_evaluations;
DELIMITER $$
CREATE PROCEDURE get_evaluations(IN charity_input VARCHAR(128))
	BEGIN
	SELECT charity_name AS "charity", evaluator_name AS "evaluator", evaluation_year AS "year", effectiveness_rank AS "rank" FROM evaluation 
    LEFT JOIN charity
    ON evaluation.charity = charity.charity_id
    LEFT JOIN evaluator
    ON evaluation.evaluator = evaluator.evaluator_id
    WHERE charity.charity_name = charity_input
    ORDER BY evaluation_year;
	END$$
	DELIMITER ;
    
-- CALL get_evaluations("Evidence Action");

	-- 2. Get a list of all the evaluators
DROP PROCEDURE IF EXISTS get_evaluator;
DELIMITER $$
CREATE PROCEDURE get_evaluator()
	BEGIN
	SELECT DISTINCT evaluator_name as "Evaluator", evaluator_website AS "website" FROM evaluator;
	END$$
	DELIMITER ;

-- CALL get_evaluator();

-- table: donation
	-- 1. total donations for a charity 
DROP PROCEDURE IF EXISTS get_charity_donations;
DELIMITER $$
CREATE PROCEDURE get_charity_donations(IN charity_input VARCHAR(128))
	BEGIN
	SELECT charity_name as "charity", SUM(donation_amount) as "total donations" FROM donation
    LEFT JOIN donor
    ON donation.donation_donor = donor.donor_id 
    LEFT JOIN charity 
    ON donation.donation_charity = charity.charity_id
    WHERE charity_name = charity_input
    GROUP BY donation_amount;
	END$$
	DELIMITER ;

-- table: project
	-- 1. all projects for a given charity

DROP PROCEDURE IF EXISTS get_charity_projects;
DELIMITER $$
CREATE PROCEDURE get_charity_projects(IN charity_input VARCHAR(128))
	BEGIN
	SELECT charity_name AS "charity", project_name AS "project", year_init AS "year started", project_status AS "project status" FROM project
    LEFT JOIN charity 
    ON project.charity = charity.charity_id
    WHERE charity_name = charity_input;
	END$$
	DELIMITER ;

-- table: source
	-- 1. get all sources

DROP PROCEDURE IF EXISTS get_sources;
DELIMITER $$
CREATE PROCEDURE get_sources()
	BEGIN
	SELECT source_name AS "source" FROM source;
	END$$
	DELIMITER ;    

-- CALL get_sources();
    
-- table: country
	-- 1. get all countries

DROP PROCEDURE IF EXISTS get_countries;
DELIMITER $$
CREATE PROCEDURE get_countries()
	BEGIN
	SELECT country_name AS "country" FROM country;
	END$$
	DELIMITER ;    
    
-- CALL get_countries();

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
    
DROP PROCEDURE IF EXISTS get_specific_donbor;
DELIMITER $$
CREATE PROCEDURE get_specific_donbor(id INT)
	BEGIN
	SELECT * FROM donor WHERE donor_id = id;
	END
	DELIMITER ;  

-- table: problem
	-- 1. get all problems

DROP PROCEDURE IF EXISTS get_problem;
DELIMITER $$
CREATE PROCEDURE get_problem()
	BEGIN
	SELECT * FROM problems;
	END $$
	DELIMITER ;   
    
    -- 2. get problem for a specific cause

DROP PROCEDURE IF EXISTS get_problem_for_cause;
DELIMITER $$
CREATE PROCEDURE get_problem_for_cause(cause_ VARCHAR(128))
	BEGIN
	SELECT problem_name AS "problem" FROM problems
    LEFT JOIN cause_area
    ON problem.cause = cause_area.cause_id
    WHERE cause_name = cause_;
	END $$
	DELIMITER ;   
    
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
CREATE PROCEDURE update_charity(id INT, name VARCHAR(64), cause VARCHAR(64), description VARCHAR(64), type VARCHAR(64),
	country VARCHAR(64), link VARCHAR(64), website VARCHAR(64))
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
	-- 1. update qaly for an intervention

DROP PROCEDURE IF EXISTS update_intervention;
DELIMITER $$
CREATE PROCEDURE update_intervention(name VARCHAR(64), prob VARCHAR(64), qaly_ DECIMAL(4, 2))
	BEGIN
	UPDATE intervention
    SET qaly = qaly_
    WHERE (intervention_name = name AND problem = prob);
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

/* ------------------------- */

-- ** INSERT **

-- table: donor
	-- 1. insert new donor: 
		-- notes: takes country, actual source, actual income
        
DROP PROCEDURE IF EXISTS insert_donor;
DELIMITER $$
CREATE PROCEDURE insert_donor(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128), 
country VARCHAR(128), source_ VARCHAR(128),income DECIMAL(9,2))
	BEGIN
    DECLARE country_id INT;
    DECLARE source_id INT;
    DECLARE percentile DECIMAL(4, 2);
    SET country_id = get_country_id(country);
    SET source_id = get_source_id(source_);
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
type VARCHAR(128), cause VARCHAR(128),link VARCHAR(128))
	BEGIN
    DECLARE cause_id INT;
    SET cause_id = get_cause_id(cause);
    INSERT INTO charity(charity_name, charity_website, charity_description, charity_type, charity_cause, donations_link) 
    VALUES (name, website, description, type, cause_id, link);
	END$$
	DELIMITER ; 
    
-- table: cause_area
	-- 1. insert new cause
		-- notes: takes actual

DROP PROCEDURE IF EXISTS insert_cause;
DELIMITER $$
CREATE PROCEDURE insert_cause(name VARCHAR(128))
	BEGIN
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
CREATE PROCEDURE insert_problem(prob VARCHAR(128), cause_ VARCHAR(128))
	BEGIN
    DECLARE cause_id INT;
    SET cause_id = get_cause_id(cause_);
    IF cause_id IS NULL THEN -- if the cause does not exist yet, create one
		CALL insert_cause(cause_);
        SET cause_id = get_cause_id(cause_);
	END IF;
    IF NOT EXISTS (SELECT * FROM problem WHERE problem_name = prob) THEN -- if problem does not already exist, create one
    INSERT INTO problem(problem_name, cause) VALUES (prob, cause_id);
    END IF;
	END$$
	DELIMITER ; 
    
    
-- table: intervention
	-- 1. insert intervention
		-- notes: takes actual values of problem

DROP PROCEDURE IF EXISTS insert_intervention;
DELIMITER $$
CREATE PROCEDURE insert_intervention(name VARCHAR(128), qaly_ DECIMAL(4,2), prob VARCHAR(128))
	BEGIN
    DECLARE problem_id INT;
    SET problem_id = get_problem_id(prob);
    IF problem_id IS NULL THEN -- check if problem exists, if not, insert one
		CALL insert_problem(prob);
        SET problem_id = get_problem_id(prob);
    INSERT INTO intervention(intervention_name, qaly, problem) VALUES (name, qaly_, problem_id);
    END IF;
	END$$
	DELIMITER ; 
    
-- table: project
	-- 1. insert project
		-- notes: takes actual values of problem

DROP PROCEDURE IF EXISTS insert_project;
DELIMITER $$
CREATE PROCEDURE insert_project(intervention_ VARCHAR(128), charity VARCHAR(128), name VARCHAR(128), year INT, status VARCHAR(128))
	BEGIN
    DECLARE charity_id INT;
    SET charity_id = get_charity_id(charity);
    INSERT INTO project(intervention, charity, project_name, year_init, project_status)
    VALUES (intervention_, charity_id, name, year, status);
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
	-- notes: delete donor based on first/last names and email
DROP PROCEDURE IF EXISTS delete_donor;
DELIMITER $$
CREATE PROCEDURE delete_donor(email VARCHAR(128), first VARCHAR(128), last VARCHAR(128))
	BEGIN
    DELETE FROM donor WHERE first_name = first AND last_name = last AND email = mail;
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

-- FUNCTIONS 
    
-- table: income rank
	-- 1. get income rank based on income
DROP FUNCTION IF EXISTS get_income_rank; 
DELIMITER $$
CREATE FUNCTION get_income_rank(income DECIMAL(9,2))
   RETURNS DECIMAL(4, 2) DETERMINISTIC
   CONTAINS SQL
   BEGIN 
   DECLARE rank_ DECIMAL(4, 2) DEFAULT 0;
   DECLARE total_ranks INT;
   DECLARE counter INT DEFAULT 0;
   SET total_ranks = (SELECT COUNT(*) FROM income_rank);
   
   WHILE counter <= total_ranks DO
        IF (SELECT annual_income FROM income_rank LIMIT counter, 1) > rank_ AND
        (SELECT annual_income FROM income_rank LIMIT counter, 1) < income THEN
			SET rank_ = (SELECT percentile FROM income_rank LIMIT counter, 1);
		END IF;
        SET counter = counter + 1;
		END WHILE;
   RETURN(rank_); 
   END $$
   
   DELIMITER ; 
   


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
    -- 2. get evaluator ID for a given evaluator name
    
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
    -- 2. get country ID for a given country name
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

-- MY STATS -- 

-- 1. My income ranking 
DROP PROCEDURE IF EXISTS my_income_rank;
DELIMITER $$
CREATE PROCEDURE my_income_rank(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128))
	BEGIN
    SELECT income_rank AS "income percentile" FROM donor WHERE (first_name = first AND last_name = last AND email = mail);
	END$$
	DELIMITER ; 
    
-- 1. My donations
DROP PROCEDURE IF EXISTS my_donations;
DELIMITER $$
CREATE PROCEDURE my_donations(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128))
	BEGIN
    DECLARE donorID INT;
    SELECT donor_id INTO donorID FROM donor WHERE (first_name = first AND last_name = last AND email = mail); -- get the donor ID
    SELECT donation_charity AS "charity", SUM(donation_amount) AS "amount donated" FROM
    donation WHERE donation_donor = donor_id
    GROUP BY donation_charity;
	END$$
	DELIMITER ; 

-- 3. Avg donation by people in the same income rank

DROP PROCEDURE IF EXISTS average_donations_per_income_rank;
DELIMITER $$
CREATE PROCEDURE average_donations_per_income_rank(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128))
	BEGIN
    DECLARE rank_ INT;
    SELECT income_rank INTO rank_ FROM donor WHERE (first_name = first AND last_name = last AND email = mail); -- get the donor rank
    SELECT AVG(donation_amount) AS "Average donation" FROM
    donation WHERE donation_donor IN (SELECT donor_id FROM donor WHERE income_rank = rank_)
    GROUP BY donation_donor;
	END$$
	DELIMITER ;


