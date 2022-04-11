DROP DATABASE IF EXISTS effective_giving;
CREATE DATABASE IF NOT EXISTS effective_giving;

USE effective_giving;

DROP TABLE IF EXISTS country;
CREATE TABLE country(
	country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(64) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS cause_area;
CREATE TABLE cause_area(
	cause_id INT AUTO_INCREMENT PRIMARY KEY,
    cause_name VARCHAR(64) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS problem;
CREATE TABLE problem(
	problem_id INT AUTO_INCREMENT PRIMARY KEY,
    problem_name VARCHAR(64) UNIQUE NOT NULL,
    cause INT NOT NULL,
    FOREIGN KEY (cause) REFERENCES cause_area(cause_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS intervention;
-- an interventions is a weak entity in relation to problem
CREATE TABLE intervention(
    intervention_name VARCHAR(64) UNIQUE NOT NULL,
    qaly DECIMAL(4,2),
    problem INT NOT NULL,
    PRIMARY KEY (intervention_name, problem),
    FOREIGN KEY (problem) REFERENCES problem(problem_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ❓ Can I subtype charities with an enum?

DROP TABLE IF EXISTS charity;
CREATE TABLE charity(
	charity_id INT AUTO_INCREMENT PRIMARY KEY,
	charity_name VARCHAR(64) UNIQUE NOT NULL,
	charity_website VARCHAR(64) NOT NULL,
	charity_description VARCHAR(256) NOT NULL,
    charity_type ENUM("Community", "Program Delivery", "Research") NOT NULL,
    charity_cause INT NOT NULL,
	charity_country INT,
    donations_link VARCHAR(64),
	FOREIGN KEY (charity_cause) REFERENCES cause_area(cause_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS project;
-- a project is a weak entity in relation to both charity and intervention
CREATE TABLE project (
	-- checking that the cause area of the project matches the cause area of the charity
	intervention VARCHAR(64) NOT NULL,
    charity INT NOT NULL,
    project_name VARCHAR(64) NOT NULL, 
	year_init YEAR NOT NULL,
	project_status ENUM("Active", "Completed", "Planned", "Frozen"),
    PRIMARY KEY (project_name, charity, intervention),
    FOREIGN KEY (intervention) REFERENCES intervention(intervention_name)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (charity) REFERENCES charity(charity_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS evaluator;
-- the name of this entity in the ERD is "Evaluating Organization"
CREATE TABLE evaluator(
	evaluator_id INT AUTO_INCREMENT PRIMARY KEY,
    evaluator_name VARCHAR(128) UNIQUE NOT NULL,
    evaluator_website VARCHAR(64) NOT NULL
);

-- ❓ there can be many evaluations for the same charity with different rankings and YEARS - 
	-- does it mean we create a separate evaluation table instead of adding evaluate attributes to charity?
-- ❓ there can only be 10 most ranked charities in one year - how to restrict adding a charity with the same ranking in one year?
	-- make rank and year a PK?

DROP TABLE IF EXISTS evaluation;
-- the name of this relationship in the ERD is "Evaluates"
CREATE TABLE evaluation (
	evaluator INT NOT NULL,
    charity INT NOT NULL,
	evaluationYear YEAR, 
    
    -- ❓ should I use an enum here or some other syntax?
    
    effectivenessRank ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10'),
    -- each evaluator makes a rating of organizations each year
    PRIMARY KEY (evaluationYear, effectivenessRank, evaluator),
    FOREIGN KEY (evaluator) REFERENCES evaluator(evaluator_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (charity) REFERENCES charity(charity_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS income_rank;
CREATE TABLE income_rank(
	percentile DECIMAL(4,2) PRIMARY KEY,
    annual_income DECIMAL (9,2) NOT NULL
);

DROP TABLE IF EXISTS source;
CREATE TABLE source(
	source_id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(64) NOT NULL
);

DROP TABLE IF EXISTS donor;
CREATE TABLE donor(
	donor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    email VARCHAR(64) UNIQUE NOT NULL,
    donor_country INT,
    source INT,
    income_rank DECIMAL(4,2),
    FOREIGN KEY (donor_country) REFERENCES country(country_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (source) REFERENCES source(source_id)
		ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (income_rank) REFERENCES income_rank(percentile)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS donation;
CREATE TABLE donation(
	donation_id INT AUTO_INCREMENT PRIMARY KEY,
	donation_donor INT,
    donation_charity INT NOT NULL,
    donation_datetime DATETIME NOT NULL,
    donation_amount INT NOT NULL,
	FOREIGN KEY (donation_donor) REFERENCES donor(donor_id)
		ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY (donation_charity) REFERENCES charity(charity_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);