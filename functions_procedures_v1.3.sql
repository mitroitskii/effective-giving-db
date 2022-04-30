-- FUNCTIONS / PROCEDURES

USE effective_giving;

/*----------------------*/

-- TABLE: cause_area

	-- 1. get all causes
DROP PROCEDURE IF EXISTS getCauseAreas;
DELIMITER $$
CREATE PROCEDURE getCauseAreas()
	BEGIN
	SELECT cause_id AS "ID", cause_name AS "Causes" FROM cause_area;
	END$$
DELIMITER ;

	-- 2. update cause

DROP PROCEDURE IF EXISTS updateCauseArea;
DELIMITER $$
CREATE PROCEDURE updateCauseArea(id INT, cause VARCHAR(64))
	BEGIN
	IF id NOT IN (SELECT cause_id FROM cause_area) THEN -- generate error if cause does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause does not exist';
	ELSE
		UPDATE cause_area
		SET cause_name = cause
		WHERE cause_id = id;
    END IF;
	END$$
	DELIMITER ;  
    
    -- 3. add cause
    
DROP PROCEDURE IF EXISTS addCauseArea;
DELIMITER $$
CREATE PROCEDURE addCauseArea(name VARCHAR(128))
	BEGIN
	IF name IN (SELECT cause_name FROM cause_area) THEN -- generate error if donor already exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause already exists';
    ELSE
		INSERT INTO cause_area(cause_name) VALUES (name);
    END IF;
	END$$
	DELIMITER ; 
    
    -- CALL addCauseArea("Women's Rights");
    
    -- 4. delete cause

DROP PROCEDURE IF EXISTS deleteCause;
DELIMITER $$
CREATE PROCEDURE deleteCause(ID INT)
	BEGIN
    DELETE FROM cause_area WHERE cause_id = ID;
	END$$
	DELIMITER ; 

    -- 5. get cause ID for a given cause 
    
DROP FUNCTION IF EXISTS getCauseId;
DELIMITER $$
CREATE FUNCTION getCauseId(cause VARCHAR(128))
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
    
    
/*----------------------*/

-- TABLE: intervention
	-- 1. get all interventions for a given cause

DROP PROCEDURE IF EXISTS getInterventionForCause;
DELIMITER $$
CREATE PROCEDURE getInterventionForCause(IN cause INT)
	BEGIN
	IF cause NOT IN (SELECT cause_id FROM cause_area) THEN -- generate error if cause does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause does not exist';
	ELSE 
		SELECT DISTINCT intervention_name FROM 
		(SELECT * FROM intervention
		LEFT JOIN problem 
		ON intervention.problem = problem.problem_id) AS T
		WHERE T.cause = cause;
    END IF;
	END$$
	DELIMITER ;
    
-- CALL getInterventionForCause(10);

	-- 2. get all interventions for a given problem

DROP PROCEDURE IF EXISTS getInterventions;
DELIMITER $$
CREATE PROCEDURE getInterventions(IN prob INT)
	BEGIN
	IF prob NOT IN (SELECT problem_id FROM problem) THEN -- generate error if problem does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Problem does not exist';
	ELSE
		SELECT intervention_name FROM intervention
		WHERE problem = prob;
	END IF;
	END$$
	DELIMITER ;
    
-- CALL getInterventions(89);
	
    -- 3. get all charities that have projects in a specific intervention
    
DROP PROCEDURE IF EXISTS getInterventionCharities;
DELIMITER $$
CREATE PROCEDURE getInterventionCharities(IN interv_ VARCHAR(128))
	BEGIN
	IF interv_ NOT IN (SELECT intervention_name FROM intervention) THEN -- generate error if intervention does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Intervention does not exist';
	ELSE
		SELECT DISTINCT charity_id AS "id", charity_name AS "charity", charity_website AS "website", charity_description AS "description", charity_type AS
		"charity type" FROM project 
		LEFT JOIN charity
		ON project.charity = charity.charity_id
		WHERE intervention = interv_;
	END IF;
	END$$
	DELIMITER ;

-- CALL getInterventionCharities("cats surgery");

	-- 4. update intervention
    
DROP PROCEDURE IF EXISTS updateIntervention;
DELIMITER $$
CREATE PROCEDURE updateIntervention(old_name VARCHAR(64), new_name VARCHAR(64), old_prob INT, new_prob INT, qaly_ DECIMAL(4, 2))
	BEGIN
    -- error message for duplicates
	IF (old_name, old_prob) NOT IN (SELECT intervention_name, problem FROM intervention) THEN -- generate error if intervention does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Intervention does not exist';
	ELSEIF (new_name, new_prob) IN (SELECT intervention_name, problem FROM intervention) THEN -- generate error if new intervention exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Intervention already exists';
    ELSE
		UPDATE intervention
		SET intervention_name = new_name, problem = new_prob
		WHERE (intervention_name = old_name AND problem = old_prob);
		-- update qaly if not null
		IF qaly_ IS NOT NULL THEN
			UPDATE intervention
			SET qaly = qaly_
			WHERE (intervention_name = new_name AND problem = new_prob);
		END IF;
	END IF;
	END$$
	DELIMITER ; 

-- CALL updateIntervention("Animal rights advocacy", "Animal rights advocacy", 7, 7, 2.5);

	-- 5. insert intervention

DROP PROCEDURE IF EXISTS addIntervention;
DELIMITER $$
CREATE PROCEDURE addIntervention(name VARCHAR(128), qaly_ DECIMAL(4,2), prob INT)
	BEGIN
    IF (name, prob) IN (SELECT intervention_name, problem FROM intervention) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Intervention already exists';
	ELSE
		INSERT INTO intervention(intervention_name, qaly, problem) VALUES (name, qaly_, prob);
    END IF;
	END$$
	DELIMITER ; 

	-- 6. delete intervention
    
DROP PROCEDURE IF EXISTS deleteIntervention;
DELIMITER $$
CREATE PROCEDURE deleteIntervention(name VARCHAR(128), prob INT)
	BEGIN
    DELETE FROM intervention WHERE intervention_name = name AND problem = prob;
	END$$
	DELIMITER ; 


/*----------------------*/

-- TABLE: charity
	-- 1. get all charities for a given cause

DROP PROCEDURE IF EXISTS getCharitiesFromCause;
DELIMITER $$
CREATE PROCEDURE getCharitiesFromCause(IN id INT)
	BEGIN
	IF id NOT IN (SELECT cause_id FROM cause_area) THEN -- generate error if cause does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause does not exist';
    ELSE
		SELECT charity_id AS "id", charity_name AS "charity", charity_website AS "website", charity_description AS "description", charity_type AS
		"charity type" FROM
		charity
		WHERE charity_cause = id; 
	END IF;
    END$$
	DELIMITER ;
    
-- CALL getCharitiesFromCause(19);

    -- 2. Get top charities for a given cause by a given evaluator in the latest year - USER END

DROP PROCEDURE IF EXISTS topCharitiesCauseEvaluator;
DELIMITER $$
CREATE PROCEDURE topCharitiesCauseEvaluator(IN cause INT, evaluator_ INT)
	BEGIN
    DECLARE year INT;
	IF cause NOT IN (SELECT cause_id FROM cause_area) THEN -- generate error if cause does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause does not exist';
    ELSEIF evaluator_ NOT IN (SELECT evaluator_id FROM evaluator) THEN -- generate error if evaluator does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Evaluator does not exist'; 
    ELSE
		SELECT MAX(evaluation_year) INTO year FROM evaluation;
		SELECT charity as "id", charity_name AS "charity", effectiveness_rank AS "rank", charity_website AS "website", charity_description AS "description", 
		charity_type AS "charity type" FROM
		(SELECT * FROM evaluation 
			LEFT JOIN charity -- evaluation x charity
			ON evaluation.charity = charity.charity_id
			WHERE (charity.charity_cause = cause AND evaluation_year = year AND evaluator = evaluator_)
			ORDER BY effectiveness_rank DESC) AS T1; 
	END IF;
	END$$
	DELIMITER ;
	
-- CALL topCharitiesCauseEvaluator(1, 14);

	-- 3. Get a list of charities based on the first input letter

DROP PROCEDURE IF EXISTS getCharitiesLetter;
DELIMITER $$
CREATE PROCEDURE getCharitiesLetter(letter VARCHAR(8))
	BEGIN
	SELECT charity_id AS "id", charity_name AS "charity", charity_description AS "description",
    charity_website AS "website", charity_type AS "type" FROM charity WHERE left(charity_name, 1) = letter;
	END$$
	DELIMITER ;  
    
    -- 4. Get top charities by a given evaluator for the latest year

DROP PROCEDURE IF EXISTS getLastEvaluatedCharities;
DELIMITER $$
CREATE PROCEDURE getLastEvaluatedCharities(evaluator_ INT)
	BEGIN
    DECLARE year INT;
	IF evaluator_ NOT IN (SELECT evaluator_id FROM evaluator) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Evaluator does not exist';
	ELSE
		SELECT MAX(evaluation_year) INTO year FROM evaluation;
		SELECT charity as "ID", charity_name AS "charity", effectiveness_rank AS "rank", charity_website AS "website", charity_description AS "description", 
		charity_type AS "charity type" FROM
		(SELECT * FROM evaluation 
			LEFT JOIN charity -- evaluation x charity
			ON evaluation.charity = charity.charity_id
			WHERE (evaluation_year = year AND evaluator = evaluator_)
			ORDER BY effectiveness_rank) AS T1; 
	END IF;
	END$$
	DELIMITER ;

-- CALL getLastEvaluatedCharities(42);

	-- 5. Get charity types

DROP PROCEDURE IF EXISTS getCharityTypes;
DELIMITER $$
CREATE PROCEDURE getCharityTypes()
	BEGIN
	SELECT DISTINCT charity_type FROM charity;
	END$$
	DELIMITER ;
	
    -- 6. get all charities
    
DROP PROCEDURE IF EXISTS getAllCharities;
DELIMITER $$
CREATE PROCEDURE getAllCharities()
	BEGIN
	SELECT * FROM charity;
	END$$
	DELIMITER ;

	-- 7. update charity
    
DROP PROCEDURE IF EXISTS updateCharity;
DELIMITER $$
CREATE PROCEDURE updateCharity(id INT, name VARCHAR(64), cause INT, website VARCHAR(64), description VARCHAR(64), type VARCHAR(64),
	country INT, link VARCHAR(64))
	BEGIN
	IF id NOT IN (SELECT charity_id FROM charity) THEN -- generate error if charity does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Charity does not exist';
	ELSE 
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
	END IF;
	END$$
	DELIMITER ;     
    
-- CALL update_charity(1, NULL,NULL, NULL , 2, NULL, NULL, NULL);

	-- 8. add charity

DROP PROCEDURE IF EXISTS addCharity;
DELIMITER $$
CREATE PROCEDURE addCharity(name VARCHAR(128), cause INT, website VARCHAR(128), description VARCHAR(128),  
type VARCHAR(128),link VARCHAR(128))
	BEGIN
	IF name IN (SELECT charity_name FROM charity) THEN -- generate error if donor already exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Charity already exists';
    ELSE
		INSERT INTO charity(charity_name, charity_website, charity_description, charity_type, charity_cause, donations_link) 
		VALUES (name, website, description, type, cause, link);
	END IF;
    END$$
	DELIMITER ; 
    
-- CALL addCharity("meow", 2, "sss", "ssss", "Program Delivery", "ddddd");

	-- 9. delete charity

DROP PROCEDURE IF EXISTS deleteCharity;
DELIMITER $$
CREATE PROCEDURE deleteCharity(charity INT)
	BEGIN
    DELETE FROM charity WHERE charity_id = charity;
	END$$
	DELIMITER ;


    -- 10. get charity ID for a given charity name
    
DROP FUNCTION IF EXISTS getCharityId;
DELIMITER $$
CREATE FUNCTION getCharityId(name VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SELECT charity_id INTO id FROM charity
    WHERE charity_name = name; 
    RETURN id;
	END$$
	DELIMITER ; 
    
    
/*----------------------*/

-- TABLE: evaluator
	-- 1. Get evaluations by all evaluators of a given charity over time

DROP PROCEDURE IF EXISTS getCharityEvaluations;
DELIMITER $$
CREATE PROCEDURE getCharityEvaluations(IN charity_ INT)
	BEGIN
	IF charity_ NOT IN (SELECT charity_id FROM charity) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Charity does not exist';
	ELSE 
		SELECT charity_name AS "charity", evaluator_name AS "evaluator", evaluation_year AS "year", effectiveness_rank AS "rank" FROM evaluation 
		LEFT JOIN charity
		ON evaluation.charity = charity.charity_id
		LEFT JOIN evaluator
		ON evaluation.evaluator = evaluator.evaluator_id
		WHERE charity = charity_
		ORDER BY evaluation_year;
    END IF;
	END$$
	DELIMITER ;
    
-- CALL getCharityEvaluations(39);

	-- 2. Get a list of all the evaluators that have evaluations
DROP PROCEDURE IF EXISTS getEvaluators;
DELIMITER $$
CREATE PROCEDURE getEvaluators()
	BEGIN
	SELECT DISTINCT evaluator_id AS "ID", evaluator_name as "Evaluator", evaluator_website AS "Website" FROM evaluator
    WHERE evaluator_id IN (SELECT evaluator FROM evaluation);
	END$$
	DELIMITER ;

-- CALL getEvaluators();

	-- 3. update evaluator

DROP PROCEDURE IF EXISTS updateEvaluator;
DELIMITER $$
CREATE PROCEDURE updateEvaluator(ID INT, new_name VARCHAR(128), website VARCHAR(128))
	BEGIN
	IF (new_name, website) IN (SELECT evaluator_name, evaluator_website FROM evaluator) THEN -- generate error if evaluator already exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Evaluator already updated';
	ELSEIF (ID) NOT IN (SELECT evaluator_id FROM evaluator) THEN -- generate error if evaluator does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Evaluator does not exist';
	ELSE	
        UPDATE EVALUATOR
		SET evaluator_name = new_name, evaluator_website = website
		WHERE (evaluator_id = ID);
    END IF;
	END$$
	DELIMITER ; 

-- CALL updateEvaluator(2, "GiveWell", "2SDFSDF");

	-- 4. add evaluator

DROP PROCEDURE IF EXISTS addEvaluator;
DELIMITER $$
CREATE PROCEDURE addEvaluator(evaluator VARCHAR(128), website VARCHAR(128))
	BEGIN
    IF evaluator IN (SELECT evaluator_name FROM evaluator) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Evaluator already exists';
	ELSE
    INSERT INTO evaluator(evaluator_name, evaluator_website) VALUES (evaluator, website);
    END IF;
	END$$
	DELIMITER ; 

	-- 5. delete evaluator
	
DROP PROCEDURE IF EXISTS deleteEvaluator;
DELIMITER $$
CREATE PROCEDURE deleteEvaluator(ID INT)
	BEGIN
    DELETE FROM evaluator WHERE evaluator_id = ID;
	END$$
	DELIMITER ; 

    -- 6. get evaluator ID for a given evaluator name
    
DROP FUNCTION IF EXISTS getEvaluatorId;
DELIMITER $$
CREATE FUNCTION getEvaluatorId(name VARCHAR(128))
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE id INT;
    SELECT evaluator_id INTO id FROM evaluator
    WHERE evaluator_name = name; 
    RETURN id;
	END$$
	DELIMITER ;  
    
    
/*----------------------*/

-- TABLE: donation

	-- 1. total donations for a charity 
DROP PROCEDURE IF EXISTS get_charity_donations;
DELIMITER $$
CREATE PROCEDURE get_charity_donations(IN charity_ INT)
	BEGIN
	IF charity_ NOT IN (SELECT charity_id FROM charity) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Charity does not exist';
	ELSE 
		SELECT charity_name as "charity", SUM(donation_amount) as "total donations" FROM 
		(SELECT * FROM donation
		LEFT JOIN charity 
		ON donation_charity = charity.charity_id
		WHERE donation_charity = charity_) AS T
		GROUP BY donation_charity;
    END IF;
	END$$
	DELIMITER ;

-- CALL get_charity_donations(109);

	-- 2. add donation
    
DROP PROCEDURE IF EXISTS addDonation;
DELIMITER $$
CREATE PROCEDURE addDonation(donor INT, charity INT, amount INT)
	BEGIN
    DECLARE date DATETIME;
    SET date = NOW();
    INSERT INTO donation(donation_donor, donation_charity, donation_datetime, donation_amount) VALUES 
    (donor, charity, date, amount);
	END$$
	DELIMITER ; 

-- CALL addDonation(1, 2, 100);


/*----------------------*/

-- TABLE: project

	-- 1. all projects for a given charity

DROP PROCEDURE IF EXISTS getCharityProjects;
DELIMITER $$
CREATE PROCEDURE getCharityProjects(IN charity_ INT)
	BEGIN
	IF charity_ NOT IN (SELECT charity_id FROM charity) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Charity does not exist';
	ELSE 
		SELECT charity_name AS "charity", project_name AS "project", year_init AS "year started", project_status AS "project status" FROM project
		LEFT JOIN charity 
		ON project.charity = charity.charity_id
		WHERE charity = charity_;
	END IF;
	END$$
	DELIMITER ;

-- CALL getCharityProjects(40);
	
    -- 2. get all projects

DROP PROCEDURE IF EXISTS getAllProjects;
DELIMITER $$
CREATE PROCEDURE getAllProjects()
	BEGIN
	SELECT * FROM project;
	END$$
	DELIMITER ;

	-- 3. get all projects in an intervention 
    
DROP PROCEDURE IF EXISTS getInterventionProjects;
DELIMITER $$
CREATE PROCEDURE getInterventionProjects(inter VARCHAR(128))
	BEGIN
	IF inter NOT IN (SELECT intervention_name FROM intervention) THEN -- generate error if intervention does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Intervention does not exist';
	ELSE
		SELECT * FROM project
		WHERE intervention = inter;
	END IF;
	END$$
	DELIMITER ;

-- CALL getInterventionProjects("Improving welfare CAT for farmed animals");
	
    -- 4. update project status
    
DROP PROCEDURE IF EXISTS updateProjectStatus;
DELIMITER $$
CREATE PROCEDURE updateProjectStatus(name VARCHAR(64), charity_ INT, interv VARCHAR(64), status VARCHAR(64))
	BEGIN
	IF (name, interv, charity_) NOT IN (SELECT project_name, intervention, charity FROM project) THEN -- generate error if project does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Project does not exist';
	ELSE
		UPDATE project
		SET project_status = status
		WHERE (project_name = name AND intervention = interv AND charity = charity_);
	END IF;
	END$$
	DELIMITER ;  

-- CALL updateProjectStatus("cat", 35, "Improving welfare standards for farmed animals", "Active");
	
    -- 5. add project

DROP PROCEDURE IF EXISTS addProject;
DELIMITER $$
CREATE PROCEDURE addProject(intervention_ VARCHAR(128), charity_ INT, name VARCHAR(128), year INT, status VARCHAR(128))
	BEGIN
    -- check if project doesn't already exist
    IF (intervention_, charity_, name) IN (SELECT intervention, charity, project_name FROM project) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Project already exists';
	ELSEIF (year < 1970 OR year > YEAR(NOW())) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid year';    
	ELSEIF checkCauseAreaMatch(intervention_, charity_) IS FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "Intervention and Charity's cause don't match";
	ELSE
		INSERT INTO project(intervention, charity, project_name, year_init, project_status)
		VALUES (intervention_, charity_, name, year, status);
	END IF;
	END$$
	DELIMITER ; 
    
-- CALL addProject("Improving welfare standards for farmed animals", 15, "coon", 2027, "Active");

	-- 6. delete project 
    
DROP PROCEDURE IF EXISTS deleteProject;
DELIMITER $$
CREATE PROCEDURE deleteProject(interv_ VARCHAR(128), charity_ INT, project VARCHAR(128))
	BEGIN
    DELETE FROM project WHERE intervention = (128) AND charity = charity_ AND project_name = project;
	END$$
	DELIMITER ; 
    

/*----------------------*/

-- TABLE: source

	-- 1. get all sources

DROP PROCEDURE IF EXISTS getSources;
DELIMITER $$
CREATE PROCEDURE getSources()
	BEGIN
	SELECT source_id AS "ID", source_name AS "source" FROM source;
	END$$
	DELIMITER ;    

-- CALL get_sources();
    
    
    -- 2. add source
    
DROP PROCEDURE IF EXISTS addSource;
DELIMITER $$
CREATE PROCEDURE addSource(source VARCHAR(128))
	BEGIN
    INSERT INTO source(source_name) VALUES (source);
	END$$
	DELIMITER ; 
    
    -- 3. delete source
    
DROP PROCEDURE IF EXISTS deleteSource;
DELIMITER $$
CREATE PROCEDURE deleteSource(ID INT)
	BEGIN
    DELETE FROM source WHERE source_id = ID;
	END$$
	DELIMITER ; 
    
    -- 4. get source ID for a given source 
    
DROP FUNCTION IF EXISTS getSourceId;
DELIMITER $$
CREATE FUNCTION getSourceId(source VARCHAR(128))
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
    
    
/*----------------------*/

-- TABLE: country

	-- 1. get all countries

DROP PROCEDURE IF EXISTS getAllCountries;
DELIMITER $$
CREATE PROCEDURE getAllCountries()
	BEGIN
	SELECT country_id AS "ID", country_name AS "country" FROM country;
	END$$
	DELIMITER ;    
    
	-- 2. get all countries based on the first character

DROP PROCEDURE IF EXISTS getCountries;
DELIMITER $$
CREATE PROCEDURE getCountries(letter VARCHAR(8))
	BEGIN
	SELECT country_id AS "ID", country_name AS "country" FROM country WHERE left(country_name, 1) = letter;
	END$$
	DELIMITER ;    
    
    -- 3. get country from country_id

DROP PROCEDURE IF EXISTS getCountryFromId;
DELIMITER $$
CREATE PROCEDURE getCountryFromId(id INT)
	BEGIN
	SELECT country_name AS "country" FROM country WHERE left(country_name, 1) = country_id = id;
	END$$
	DELIMITER ;   

	-- 4. get country ID
    
DROP FUNCTION IF EXISTS getCountryId;
DELIMITER $$
CREATE FUNCTION getCountryId(country VARCHAR(128))
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

	-- 5. check if a country exists in the table or not
DROP FUNCTION IF EXISTS checkCountryExists;
DELIMITER $$
CREATE FUNCTION checkCountryExists(country VARCHAR(128))
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


/*----------------------*/

-- TABLE: donor

	-- 1. get all donors

DROP PROCEDURE IF EXISTS getAllDonors;
DELIMITER $$
CREATE PROCEDURE getAllDonors()
	BEGIN
	SELECT * FROM donor;
	END $$
	DELIMITER ;    

	-- 2. get a specific donor
    
DROP PROCEDURE IF EXISTS getDonor;
DELIMITER $$
CREATE PROCEDURE getDonor(id INT)
	BEGIN
	IF id NOT IN (SELECT donor_id FROM donor) THEN -- generate error if donor does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Donor does not exist';
	ELSE
		SELECT first_name, last_name, email, donor_country, country_name, source, source_name FROM donor 
		LEFT JOIN country
		ON donor_country = country_id
		LEFT JOIN source
		ON donor.source = source.source_id
		WHERE donor_id = id;
	END IF;
	END $$
	DELIMITER ;  

-- CALL getDonor(17);

    -- 3. check if email already exists or not
DROP FUNCTION IF EXISTS checkEmail;
DELIMITER $$
CREATE FUNCTION checkEmail(email_id VARCHAR(128))
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

    
DROP PROCEDURE IF EXISTS getDonorId;
DELIMITER $$
CREATE PROCEDURE getDonorId(IN email_id VARCHAR(128))
	BEGIN
	IF email_id NOT IN (SELECT email FROM donor) THEN -- generate error if donor does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Donor does not exist';
	ELSE    
		SELECT donor_id FROM donor WHERE email = email_id;
    END IF;
	END $$
	DELIMITER ;  

-- CALL getDonorId("da@email.com");

	-- 5. update donor
    
DROP PROCEDURE IF EXISTS updateDonor;
DELIMITER $$
CREATE PROCEDURE updateDonor(id INT, first VARCHAR(64), last VARCHAR(64), email_ VARCHAR(64), country INT, income DECIMAL(9, 2))
	BEGIN
	DECLARE rank_ DECIMAL(4, 2);
	IF id NOT IN (SELECT donor_id FROM donor) THEN -- generate error if donor does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Donor does not exist';
	ELSE 
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
	IF (country IS NOT NULL) THEN -- country
		UPDATE donor 
		SET donor_country = country
		WHERE donor_id = id;
		END IF;
	END IF;
	END$$
	DELIMITER ;     

-- CALL updateDonor(1, NULL, NULL, NULL, 3538.08, NULL); 

	-- 6. delete donor
    
DROP PROCEDURE IF EXISTS deleteDonor;
DELIMITER $$
CREATE PROCEDURE deleteDonor(donorID INT)
	BEGIN
    DELETE FROM donor WHERE donor_id = donorID;
	END$$
	DELIMITER ; 
    
    -- 7. add donor

DROP PROCEDURE IF EXISTS addDonor;
DELIMITER $$
CREATE PROCEDURE addDonor(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128),
country INT, source_ INT, income DECIMAL(9,2))
	BEGIN
    DECLARE percentile DECIMAL(4, 2);
	IF checkEmail(mail) IS FALSE THEN -- generate error if donor already exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Email ID already exists';
    ELSE
		SET percentile = getIncomeRank(income);
		INSERT INTO donor(first_name, last_name, email, donor_country, source, income_rank) 
		VALUES (first, last, mail, country, source_, percentile);
	END IF;
	END$$
	DELIMITER ; 

-- CALL addDonor("john", "smith", "jsmith@gmail.com", 2, 2, 2404.08);


/*----------------------*/

-- TABLE: problem

	-- 1. get all problems

DROP PROCEDURE IF EXISTS getProblems;
DELIMITER $$
CREATE PROCEDURE getProblems()
	BEGIN
	SELECT problem_id, problem_name, cause, cause_name FROM problem
    LEFT JOIN cause_area
    ON cause = cause_id;
	END $$
	DELIMITER ;   
    
CALL getProblems();

    -- 2. get problem for a specific cause

DROP PROCEDURE IF EXISTS getCauseProblems;
DELIMITER $$
CREATE PROCEDURE getCauseProblems(causeID INT)
	BEGIN
	IF causeID NOT IN (SELECT cause_id FROM cause_area) THEN -- generate error if cause does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause does not exist';
	ELSE
		SELECT problem_id AS "ID", problem_name AS "problem" FROM problem
		WHERE cause = causeID;
	END IF;
	END $$
	DELIMITER ;   

-- CALL getCauseProblems(12);

	-- 3. update problem
    
DROP PROCEDURE IF EXISTS updateProblem;
DELIMITER $$
CREATE PROCEDURE updateProblem(id INT, name VARCHAR(128), new_cause INT)
	BEGIN
	IF id NOT IN (SELECT problem_id FROM problem) THEN -- generate error if problem does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'problem ID does not exist';
	ELSEIF (name, new_cause) IN (SELECT problem_name, cause FROM problem) THEN -- generate error if new problem already exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'problem already exists';
	ELSE
		UPDATE problem
		SET problem_name = name, cause = new_cause
		WHERE (problem_id = id);
    END IF;
	END$$
	DELIMITER ; 

-- CALL updateProblem(1, "Factory Farming", 1);

	-- 4. add problem
    
DROP PROCEDURE IF EXISTS addProblem;
DELIMITER $$
CREATE PROCEDURE addProblem(prob VARCHAR(128), cause_ INT)
	BEGIN
    IF (prob, cause_) IN (SELECT problem_name, cause FROM problem) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Problem for this cause already exists';
	ELSE
		INSERT INTO problem(problem_name, cause) VALUES (prob, cause_);
    END IF;
	END$$
	DELIMITER ; 
    
-- CALL addProblem("Schistosomiasis", 2);

    -- 5. get problem ID for a given cause 
DROP FUNCTION IF EXISTS getProblemId;
DELIMITER $$
CREATE FUNCTION getProblemId(prob VARCHAR(128))
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
    
    
/*----------------------*/

-- TABLE: income_rank

	-- 1. get income ranking

DROP PROCEDURE IF EXISTS showIncomeRankings;
DELIMITER $$
CREATE PROCEDURE showIncomeRankings()
	BEGIN
	SELECT * FROM income_rank;
	END $$
	DELIMITER ;    
    
    -- 2. update income rank

DROP PROCEDURE IF EXISTS updateIncomeRank;
DELIMITER $$
CREATE PROCEDURE update_income_rank(income DECIMAL (9,2), perc DECIMAL(4,2))
	BEGIN
	IF income NOT IN (SELECT annual_income FROM income_rank) THEN -- generate error if evaluator already exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Income value does not exist';
	ELSE
		UPDATE income_rank
		SET percentile = perc
		WHERE (annual_income = income);
	END IF;
    END$$
	DELIMITER ; 

	-- 3. get income rank 

DROP FUNCTION IF EXISTS getIncomeRank; 
DELIMITER $$
CREATE FUNCTION getIncomeRank(income DECIMAL(9,2))
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
   
-- SELECT get_income_rank(500);


/*----------------------*/

-- TABLE: evaluation

	-- 1. get all evaluations

DROP PROCEDURE IF EXISTS getAllEvaluations;
DELIMITER $$
CREATE PROCEDURE getAllEvaluations()
	BEGIN
	SELECT * FROM evaluation;
	END $$
	DELIMITER ; 
    
    -- 2. add eval

DROP PROCEDURE IF EXISTS addEvaluation;
DELIMITER $$
CREATE PROCEDURE addEvaluation(evaluator_id INT, charity_id INT, year INT, rank_ INT)
	BEGIN
    -- check for duplicates
    IF (evaluator_id, charity_id, year, rank_) IN (SELECT * FROM evaluation) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Evaluation already exists';
	ELSEIF (year < 1970 OR year > YEAR(NOW())) THEN -- check if year is valid
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Year Invalid';
	ELSEIF (rank_ < 0 OR rank_ > 10) THEN -- check if rank is valid
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Rank Invalid';
	ELSE
        INSERT INTO evaluation(evaluator, charity, evaluation_year, effectiveness_rank) VALUES 
				(evaluator_id, charity_id, year, rank_);
	END IF;
	END$$
	DELIMITER ; 
    
-- CALL addEvaluation(4, 1, 1989, -1);

	-- 3. delete eval
	
DROP PROCEDURE IF EXISTS deleteEvaluation;
DELIMITER $$
CREATE PROCEDURE deleteEvaluation(eval INT, char_id INT, year INT)
	BEGIN
    DELETE FROM evaluation WHERE evaluator = eval AND charity = char_id AND evaluation_year = year;
	END$$
	DELIMITER ; 

-- CALL deleteEvaluation(4, 1, 1980);
    

    
/* ------------------------- */

-- MISC FUNCTIONS & PROCEDURES
    

-- 1. check cause area of an intervention and charity match
	-- returns TRUE if intervention + charity have the same cause

DROP FUNCTION IF EXISTS checkCauseAreaMatch;
DELIMITER $$
CREATE FUNCTION checkCauseAreaMatch(inter_ VARCHAR(128), char_ INT)
	RETURNS BOOLEAN DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE check_ BOOLEAN;
    SET check_ = FALSE;
    IF -- compare causes from intervention table and charity table
	(SELECT cause FROM intervention
    LEFT JOIN problem
    ON intervention.problem = problem.problem_id
    WHERE intervention_name = inter_) = 
    (SELECT charity_cause FROM charity WHERE charity_id = char_)
    THEN
		SET check_ = TRUE;
	END IF;
    RETURN check_;
	END$$
	DELIMITER ;  

-- SELECT checkCauseAreaMatch("Cash transfers", 1);


/* ------------------------- */

-- MY STATS -- DONOR

-- 1. My income ranking 
DROP PROCEDURE IF EXISTS myIncomeRank;
DELIMITER $$
CREATE PROCEDURE myIncomeRank(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128))
	BEGIN
    SELECT income_rank AS "income percentile" FROM donor WHERE (first_name = first AND last_name = last AND email = mail);
	END$$
	DELIMITER ; 
    
-- 2. a. My donations - total sum of donations 
    
DROP FUNCTION IF EXISTS getDonationsTotal;
DELIMITER $$
CREATE FUNCTION getDonationsTotal(donorID INT)
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE sum_ INT;
    SET sum_ = NULL;
	SELECT SUM(donation_amount) INTO sum_ FROM donation
    WHERE donation_donor = donorID;
    RETURN sum_;
	END$$
	DELIMITER ; 

-- SELECT getDonationsTotal(2);

-- 2. b. My donations - total number of donations
    
DROP FUNCTION IF EXISTS getNumOfDonations;
DELIMITER $$
CREATE FUNCTION getNumOfDonations(donorID INT)
	RETURNS INT DETERMINISTIC
    CONTAINS SQL
	BEGIN
    DECLARE count_ INT;
    SET count_ = NULL;
    SELECT COUNT(donation_amount) INTO count_ FROM donation 
    WHERE donation_donor = donorID;
    RETURN count_;
	END$$
	DELIMITER ; 

-- SELECT getNumOfDonations(2);

-- 2. c. My donations - causes I donated to 
DROP PROCEDURE IF EXISTS getDonationsCauses;
DELIMITER $$
CREATE PROCEDURE getDonationsCauses(donorID INT)
	BEGIN
    SELECT DISTINCT cause_name FROM donation
    LEFT JOIN charity
    ON donation_charity = charity_id
    LEFT JOIN cause_area
    ON charity.charity_cause = cause_area.cause_id
    WHERE donation_donor = donorID;
	END$$
	DELIMITER ; 

-- CALL getDonationsCauses(2);

-- 2. d. My donations - all donations
DROP PROCEDURE IF EXISTS getAllDonations;
DELIMITER $$
CREATE PROCEDURE getAllDonations(donorID INT)
	BEGIN
    SELECT charity_name, cause_name, donation_datetime, donation_amount FROM donation
    LEFT JOIN charity
    ON donation_charity = charity_id
    LEFT JOIN cause_area
    ON charity.charity_cause = cause_area.cause_id
    WHERE donation_donor = donorID;
	END$$
	DELIMITER ; 

-- CALL getAllDonations(2);

-- 3. Avg donation by people in the same income rank

DROP PROCEDURE IF EXISTS averageDonationsPerIncomeRank;
DELIMITER $$
CREATE PROCEDURE averageDonationsPerIncomeRank(donorID INT)
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

DROP PROCEDURE IF EXISTS topDonatingCountries;
DELIMITER $$
CREATE PROCEDURE topDonatingCountries()
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

DROP PROCEDURE IF EXISTS topTenSources;
DELIMITER $$
CREATE PROCEDURE topTenSources()
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

DROP PROCEDURE IF EXISTS topDonatedCharities;
DELIMITER $$
CREATE PROCEDURE topDonatedCharities()
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

DROP PROCEDURE IF EXISTS leastDonatedCharities;
DELIMITER $$
CREATE PROCEDURE leastDonatedCharities()
	BEGIN
	SELECT charity_name AS "Least donated charities" FROM donation
    LEFT JOIN charity
    ON donation_charity = charity_id
    GROUP BY charity_name
    ORDER BY SUM(donation_amount) LIMIT 10;
    END$$
	DELIMITER ;

-- CALL least_donated_charities;

