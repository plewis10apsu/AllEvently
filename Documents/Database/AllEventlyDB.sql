--CREATE DATABASE
CREATE DATABASE AllEventlyDB;

-------------CREATE TABLES----------------
--TABLE TO STORE USERS
CREATE TABLE People (
    email nvarchar(30),
    first_name nvarchar(30) NOT NULL,
    last_name nvarchar(30) NOT NULL,
    PRIMARY KEY(email)
);

--TABLE TO STORE USER ACCOUNTS
CREATE TABLE Accounts (
    account_email nvarchar(30),
    account_password nvarchar(30) NOT NULL,
    PRIMARY KEY (email),
    FOREIGN KEY (account_email) REFERENCES People (email)
);

--TABLE TO STORE ACCOUNT SESSIONS
CREATE TABLE Sessions (
    session_id nvarchar(30),
    session_email nvarchar(30) NOT NULL UNIQUE,
    PRIMARY KEY(session_id),
    FOREIGN KEY (session_email) REFERENCES Accounts (email)
);

--TABLE TO STORE RESET PASSWORD CREDENTIALS
CREATE TABLE Reset_Credentials (
    account_email nvarchar(30),
    temp_password nvarchar(30) NOT NULL,
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES Accounts (email)
);

--TABLE TO STORE IMAGE PATHS
CREATE TABLE Image (
    image_id INT,
    image_path nvarchar(30) NOT NULL,
    is_template BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (image_id)
);

--TABLE TO STORE WHICH IMAGES BELONG TO WHICH USER
CREATE TABLE User_Images (
    image_id INT,
    owner_email INT NOT NULL,
    PRIMARY KEY (image_id),
    FOREIGN KEY (image_id) REFERENCES Images (image_id),
    FOREIGN KEY (owner_email) REFERENCES People (email)
);

--TABLE TO STORE EVENTS
CREATE TABLE Events (
    event_id INT,
    event_host nvarchar(30) NOT NULL,
    host_name nvarchar(30) NOT NULL,
    event_name nvarchar(30) DEFAULT "My Event",
    event_location: nvarchar(30) NOT NULL,
    event_start_date DATE DEFAULT GETDATE()+1,
    event_end_date DATE,
    event_time_zone nvarchar(30) DEFAULT "UTC",
    invitation_layout nvarchar(30) DEFAULT "Center",
    background_image INT DEFAULT 0,
    font_background_color nvarchar(30) DEFAULT "#000000",
    font_color nvarchar(30) DEFAULT "#FFFFFF",
    font nvarchar(30) DEFAULT "italic bold 20px arial,serif",
    is_public BOOLEAN DEFAULT TRUE,
    reoccurs BOOLEAN DEFAULT FALSE,
    reoccur_freq INT,
    end_reoccur DATE,
    request_child_num BOOLEAN DEFAULT FALSE,
    limit_additional_guests BOOLEAN DEFAULT FALSE,
    max_additional_guests INT DEFAULT 0,
    notify_host BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (event_id),
    FOREIGN KEY (event_host) REFERENCES Accounts (email),
    FOREIGN KEY (background_image) REFERENCES Images (image_id)
);

--TABLE TO STORE CHAT MESSAGES
CREATE TABLE Chat_Messages (
    message_id INT,
    event_id INT NOT NULL,
    sender_email nvarchar(30) NOT NULL,
    content nvarchar(30) NOT NULL,
    sent_date DATE DEFAULT GETDATE(),
    accepted BOOLEAN,
    PRIMARY KEY (message_id),
    FOREIGN KEY (event_id) REFERENCES EVENTS (event_id),
    FOREIGN KEY (sender_email) REFERENCES People (email)
);

--TABLE TO STORE GUESTS OF EVENTS
CREATE TABLE Guests (
    guest_email nvarchar(30),
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

-----------Create Procedures-------------
--Authenticate Users
CREATE PROCEDURE Authenticate_User
@Email_Address nvarchar(30), @Pass nvarchar(30)
AS
    BEGIN
        --Get count of accounts with given email and password
        DECLARE @Count_A INT = SELECT COUNT(*) FROM Accounts
        HAVING email = @Email_Address and account_password = @Pass;

        --Check if there is only one account
        IF @Count_A = 1 {
            --Create Session
            INSERT INTO Sessions (session_email)
            VALUES (@Email_Address)

            --Get Session ID
            SELECT session_id FROM Sessions
            WHERE session_email = @Email_Address;
        }
    END
GO;

--Add Account
CREATE PROCEDURE Create_Account
@Email_Address nvarchar(30), @Pass nvarchar(30), @FName nvarchar(30), @LName nvarchar(30)
AS
    BEGIN
        --Get count of people with given address
        DECLARE @Count_P INT = SELECT COUNT(*) FROM People
        HAVING email = @Email_Address

        --Get count of accounts with given address
        DECLARE @Count_A INT = SELECT COUNT(*) FROM Accounts
        HAVING email = @Email_Address

        --Check if no account exists
        IF @Count_A = 0 {
            IF @Count_P = 0 {
                --If no person exists, make one
                INSERT INTO People (email, first_name, last_name)
                VALUES (@Email_Address, @FName, @LName)
            } ELSE IF Count_P = 1 {
                --If a person exists, update them
                UPDATE People
                SET first_name = @FName, last_name = @LName
                WHERE email = @Email_Address
            }

            --Create Account
            INSERT INTO Accounts (account_email, account_password)
            VALUES (@Email_Address, @Pass)

            --Create Session
            INSERT INTO Sessions (session_email)
            VALUES (@Email_Address)

            --Get Session ID
            SELECT session_id FROM Sessions
            WHERE session_email = @Email_Address;
        }
    END
GO;

--Create reset credentials
CREATE PROCEDURE Create_Reset_Credentials
@Email_Address nvarchar(30)
AS
    BEGIN

        --Get count of accounts with given address in Accounts
        DECLARE @Count_A INT = SELECT COUNT(*) FROM Accounts
        HAVING account_email = @Email_Address

        --Get count of accounts with given address in Reset_Credentials
        DECLARE @Count_RC INT = SELECT COUNT(*) FROM Reset_Credentials
        HAVING account_email = @Email_Address

        IF (@Count_A = 1 AND @Count_RC < 1) {

            DECLARE @rand_num INT = SELECT FLOOR(RAND()*9999999999)

            DECLARE @temp nvarchar(30) = CAST(@rand_num AS nvarchar(30))

            WHILE LEN(@temp) < 8 {
                DECLARE @diff INT = 8 - LEN(@temp)

                @rand_num = SELECT FLOOR(RAND()*(POWER(10, @diff)-1))

                @temp = @temp + CAST(@rand_num AS nvarchar(30))
            }

            INSERT INTO Reset_Credentials (account_email, temp_password)
            VALUES (@Email_Address, @temp)

            SELECT account_email, temp_password FROM Reset_Credentials
            where account_email = @Email_Address
        }
    END
GO;

--Reset Password
CREATE PROCEDURE Update_Password
@Email_Address nvarchar(30), @temp nvarchar(30), @new_pass nvarchar(30)
AS
    BEGIN
        --Get count of accounts with given address in Reset_Credentials
        DECLARE @Count_RC INT = SELECT COUNT(*) FROM Reset_Credentials
        HAVING account_email = @Email_Address AND temp_password = @temp

        IF(@Count_RC = 1) {

            DELETE FROM Reset_Credentials
            WHERE account_email = @Email_Address

            UPDATE Accounts
            SET account_password = @new_pass
            WHERE account_email = @Email_Address

        }
    END
GO;

--Get User Events


-----------Create Triggers---------------
