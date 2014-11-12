CREATE TABLE [dbo].[Fone] (
    [empresa]  INT            NOT NULL,
    [DDD]      VARCHAR (15)   COLLATE SQL_Latin1_General_Pref_CP1_CI_AS NULL,
    [telefone] VARCHAR (8000) COLLATE SQL_Latin1_General_Pref_CP1_CI_AS NULL,
    [ramal]    INT            NULL
);

