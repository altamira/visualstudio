CREATE TABLE [dbo].[Tratamento_Pessoa] (
    [cd_tratamento] INT          NOT NULL,
    [nm_tratamento] VARCHAR (40) NULL,
    [sg_tratamento] CHAR (10)    NULL,
    [cd_usurario]   INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Tratamento_Pessoa] PRIMARY KEY CLUSTERED ([cd_tratamento] ASC) WITH (FILLFACTOR = 90)
);

