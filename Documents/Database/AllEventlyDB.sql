-------------CREATE TABLES----------------
--TABLE TO STORE USERS
CREATE TABLE People (
    email varchar(30),
    first_name varchar(30) NOT NULL,
    last_name varchar(30) NOT NULL,
    PRIMARY KEY(email)
);

--TABLE TO STORE USER ACCOUNTS
CREATE TABLE Accounts (
    account_email varchar(30),
    account_password varchar(30) NOT NULL,
    PRIMARY KEY (account_email),
    FOREIGN KEY (account_email) REFERENCES People (email)
);

--TABLE TO STORE ACCOUNT SESSIONS
CREATE TABLE Sessions (
    session_id varchar(30),
    session_email varchar(30) NOT NULL UNIQUE,
    PRIMARY KEY(session_id),
    FOREIGN KEY (session_email) REFERENCES Accounts (account_email)
);

--TABLE TO STORE RESET PASSWORD CREDENTIALS
CREATE TABLE Reset_Credentials (
    account_email varchar(30),
    temp_password varchar(30) NOT NULL,
    PRIMARY KEY (account_email),
    FOREIGN KEY (account_email) REFERENCES Accounts (account_email)
);

--TABLE TO STORE IMAGE PATHS
CREATE TABLE Images (
    image_id INT,
    image_path varchar(30) NOT NULL,
    is_template BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (image_id)
);

--TABLE TO STORE WHICH IMAGES BELONG TO WHICH USER
CREATE TABLE User_Images (
    image_id INT,
    owner_email varchar(30) NOT NULL,
    PRIMARY KEY (image_id),
    FOREIGN KEY (image_id) REFERENCES Images (image_id),
    FOREIGN KEY (owner_email) REFERENCES People (email)
);

--TABLE TO STORE EVENTS
CREATE TABLE Events (
    event_id INT,
    event_host varchar(30) NOT NULL,
    host_name varchar(30) NOT NULL,
    event_name varchar(30) DEFAULT 'My Event',
    event_location varchar(30) NOT NULL,
    event_start_date DATE DEFAULT (CURRENT_DATE)+1,
    event_end_date DATE,
    event_time_zone varchar(30) DEFAULT 'UTC',
    invitation_layout varchar(30) DEFAULT 'Center',
    background_image INT DEFAULT 0,
    font_background_color varchar(30) DEFAULT '#000000',
    font_color varchar(30) DEFAULT '#FFFFFF',
    font varchar(30) DEFAULT 'italic bold 20px arial,serif',
    is_public BOOLEAN DEFAULT TRUE,
    reoccurs BOOLEAN DEFAULT FALSE,
    reoccur_freq INT,
    end_reoccur DATE,
    request_child_num BOOLEAN DEFAULT FALSE,
    limit_additional_guests BOOLEAN DEFAULT FALSE,
    max_additional_guests INT DEFAULT 0,
    notify_host BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (event_id),
    FOREIGN KEY (event_host) REFERENCES Accounts (account_email),
    FOREIGN KEY (background_image) REFERENCES Images (image_id)
);

--TABLE TO STORE CHAT MESSAGES
CREATE TABLE Chat_Messages (
    message_id INT,
    event_id INT NOT NULL,
    sender_email varchar(30) NOT NULL,
    content varchar(30) NOT NULL,
    sent_date DATE DEFAULT (CURRENT_DATE),
    accepted BOOLEAN,
    PRIMARY KEY (message_id),
    FOREIGN KEY (event_id) REFERENCES EVENTS (event_id),
    FOREIGN KEY (sender_email) REFERENCES People (email)
);

--TABLE TO STORE GUESTS OF EVENTS
CREATE TABLE Guests (
    guest_email varchar(30),
    event_id INT,
    responded BOOLEAN DEFAULT FALSE,
    invite_sent BOOLEAN DEFAULT FALSE,
    accepted BOOLEAN,
    child_count INT,
    guest_count INT,
    PRIMARY KEY (guest_email, event_id),
    FOREIGN KEY (guest_email) REFERENCES People(email),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-----------Create Functions-------------
--Authenticate Users
CREATE OR REPLACE FUNCTION Authenticate_User
(Email_Address varchar(30), Pass varchar(30)) RETURNS INT AS $$
DECLARE
	Count_A INT;
BEGIN

	Count_A := (SELECT COUNT(*) FROM Accounts
    HAVING email = Email_Address and account_password = Pass);

    --Check if there is only one account
    IF Count_A = 1 THEN
        --Create Session
        INSERT INTO Sessions (session_email)
        VALUES (Email_Address);

        --Get Session ID
        RETURN (SELECT session_id FROM Sessions
        WHERE session_email = Email_Address);
	END IF;

	RETURN NULL;
	
END $$ LANGUAGE plpgsql;

--Add Account
CREATE OR REPLACE FUNCTION Create_Account
(Email_Address varchar(30), Pass varchar(30), FName varchar(30), LName varchar(30)) RETURNS INT AS $$
DECLARE
	Count_P INT;
	Count_A INT;
BEGIN
    --Get count of people with given address
	Count_P := (SELECT COUNT(*) FROM People
    HAVING email = Email_Address);

	--Get count of accounts with given address
    Count_A := (SELECT COUNT(*) FROM Accounts
	HAVING email = Email_Address);

    --Check if no account exists
    IF Count_A = 0 THEN
        IF Count_P = 0 THEN
        	--If no person exists, make one
            INSERT INTO People (email, first_name, last_name)
            VALUES (Email_Address, FName, LName);
        ELSIF Count_P = 1 THEN
            --If a person exists, update them
            UPDATE People
            SET first_name = FName, last_name = LName
            WHERE email = Email_Address;
		END IF;

        --Create Account
        INSERT INTO Accounts (account_email, account_password)
        VALUES (Email_Address, Pass);

        --Create Session
        INSERT INTO Sessions (session_email)
        VALUES (Email_Address);

        --Get Session ID
        RETURN (SELECT session_id FROM Sessions
        WHERE session_email = Email_Address);
	END IF;

	RETURN NULL;
	
END $$ LANGUAGE plpgsql;


--Create reset credentials
CREATE OR REPLACE FUNCTION Create_Reset_Credentials
(Email_Address varchar(30)) RETURNS varchar(30) AS $$
DECLARE
	Count_A INT;
	Count_RC INT;
	rand_num INT;
	temp_pass varchar(30);
	diff INT;
BEGIN

    --Get count of accounts with given address in Accounts
    Count_A := (SELECT COUNT(*) FROM Accounts
    HAVING account_email = Email_Address);

    --Get count of accounts with given address in Reset_Credentials
    Count_RC := (SELECT COUNT(*) FROM Reset_Credentials
    HAVING account_email = Email_Address);

    IF (Count_A = 1 AND Count_RC < 1) THEN

        rand_num := (SELECT FLOOR(RAND()*9999999999));

        temp_pass := CAST(rand_num AS varchar(30));

        WHILE (LEN(temp_pass) < 8) LOOP
            diff := 8 - LEN(temp_pass);

            rand_num := (SELECT FLOOR(RAND()*(POWER(10, diff)-1)));

            temp_pass := temp_pass + CAST(rand_num AS varchar(30));
		END LOOP;

        INSERT INTO Reset_Credentials (account_email, temp_password)
        VALUES (Email_Address, temp);

        RETURN (SELECT temp_password FROM Reset_Credentials
        where account_email = Email_Address);
	END IF;

	RETURN NULL;

END $$ LANGUAGE plpgsql;


--Reset Password
CREATE OR REPLACE FUNCTION Update_Password
(Email_Address varchar(30), temp varchar(30), new_pass varchar(30))
RETURNS INT AS $$
DECLARE
	Count_RC INT;
BEGIN
    --Get count of accounts with given address in Reset_Credentials
    Count_RC := (SELECT COUNT(*) FROM Reset_Credentials
    HAVING account_email = Email_Address AND temp_password = temp);

    IF (Count_RC = 1) THEN
        DELETE FROM Reset_Credentials
        WHERE (account_email = Email_Address);

        UPDATE Accounts
        SET account_password = new_pass
        WHERE (account_email = Email_Address);
    END IF;
	
END $$ LANGUAGE plpgsql;


--Get Invited Events
CREATE OR REPLACE FUNCTION Get_Attending_Events
(Email_Address varchar(30))
RETURNS SETOF Events AS $BODY$
BEGIN

    RETURN NEXT (SELECT * FROM Events
		WHERE event_id IN (SELECT ARRAY_AGG(event_id) FROM Guests
        	WHERE guest_email = Email_Address));
		
END $BODY$ LANGUAGE plpgsql;

--Get Hosted Events
CREATE OR REPLACE FUNCTION Get_Hosted_Events
(Email_Address varchar(30))
RETURNS SETOF Events AS $BODY$
BEGIN

    RETURN NEXT (SELECT * FROM Events
    WHERE event_host = Email_Address);
	
END $BODY$ LANGUAGE plpgsql;

--Get Public Events
CREATE OR REPLACE FUNCTION Get_Public_Events ()
RETURNS SETOF Events AS $BODY$
BEGIN

    SELECT * FROM Events
    WHERE is_public = TRUE;
	
END $BODY$ LANGUAGE plpgsql;


-----------Create Triggers---------------
