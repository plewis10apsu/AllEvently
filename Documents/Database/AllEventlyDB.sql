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
CREATE PROCEDURE AuthenticateUser @Address nvarchar(30), @Pass nvarchar(30)
AS
    DECLARE @Accounts INT = SELECT COUNT(*) FROM Accounts
    WHERE email = @Address and account_password = @Pass

    IF @Accounts = 1 {
        INSERT INTO Sessions ()
    }
GO;
-----------Create Triggers---------------
