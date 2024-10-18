--CREATE DATABASE
CREATE DATABASE AllEventlyDB;

-------------CREATE TABLES----------------
--TABLE TO STORE USERS
CREATE TABLE People {
    email STRING,
    first_name STRING NOT NULL,
    last_name STRING NOT NULL,
    PRIMARY KEY(email)
};

--TABLE TO STORE USER ACCOUNTS
CREATE TABLE Accounts {
    account_email STRING,
    account_password STRING NOT NULL,
    PRIMARY KEY (email),
    FOREIGN KEY (account_email) REFERENCES People (email)
};

--TABLE TO STORE ACCOUNT SESSIONS
CREATE TABLE Sessions {
    session_id STRING,
    session_email STRING NOT NULL UNIQUE,
    PRIMARY KEY(session_id),
    FOREIGN KEY (session_email) REFERENCES Accounts (email)
};

--TABLE TO STORE RESET PASSWORD CREDENTIALS
CREATE TABLE Reset_Credentials {
    account_email STRING,
    temp_password STRING NOT NULL,
    PRIMARY KEY (email),
    FOREIGN KEY (email) REFERENCES Accounts (email)
};

--TABLE TO STORE IMAGE PATHS
CREATE TABLE Image {
    image_id INT,
    image_path STRING NOT NULL,
    is_template BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (image_id)
};

--TABLE TO STORE WHICH IMAGES BELONG TO WHICH USER
CREATE TABLE User_Images {
    image_id INT,
    owner_email INT NOT NULL,
    PRIMARY KEY (image_id),
    FOREIGN KEY (image_id) REFERENCES Images (image_id),
    FOREIGN KEY (owner_email) REFERENCES People (email)
};

--TABLE TO STORE EVENTS
CREATE TABLE Events {
    event_id INT,
    event_host STRING NOT NULL,
    host_name STRING NOT NULL,
    event_name STRING DEFAULT "My Event",
    event_location: STRING NOT NULL,
    event_start_date DATE DEFAULT GETDATE()+1,
    event_end_date DATE,
    event_time_zone STRING DEFAULT "UTC",
    invitation_layout STRING DEFAULT "Center",
    background_image INT DEFAULT 0,
    font_background_color STRING DEFAULT "#000000",
    font_color STRING DEFAULT "#FFFFFF",
    font STRING DEFAULT "italic bold 20px arial,serif",
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
};

--TABLE TO STORE CHAT MESSAGES
CREATE TABLE Chat_Messages {
    message_id INT,
    event_id INT NOT NULL,
    sender_email STRING NOT NULL,
    content STRING NOT NULL,
    sent_date DATE DEFAULT GETDATE(),
    accepted BOOLEAN,
    PRIMARY KEY (message_id),
    FOREIGN KEY (event_id) REFERENCES EVENTS (event_id),
    FOREIGN KEY (sender_email) REFERENCES People (email)
};

--TABLE TO STORE GUESTS OF EVENTS
CREATE TABLE Guests {
    guest_email STRING,
    event_id INT,
    responded BOOLEAN DEFAULT FALSE,
    invite_sent BOOLEAN DEFAULT FALSE,
    accepted BOOLEAN,
    child_count INT,
    guest_count INT
    
};
