CREATE TABLE [dbo].[CASERPRE] (
    [CPSe0Cod]    CHAR (15)       NOT NULL,
    [CPSe0Nom]    CHAR (50)       NULL,
    [CPSe0Un]     CHAR (2)        NULL,
    [CPSe0Pre]    DECIMAL (13, 4) NULL,
    [CPSe0DesDet] VARCHAR (2000)  NULL,
    PRIMARY KEY CLUSTERED ([CPSe0Cod] ASC)
);

