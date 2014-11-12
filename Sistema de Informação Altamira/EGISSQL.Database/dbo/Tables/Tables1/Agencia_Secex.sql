CREATE TABLE [dbo].[Agencia_Secex] (
    [cd_agencia_secex] INT          NOT NULL,
    [nm_agencia_secex] VARCHAR (40) NULL,
    [sg_agencia_secex] CHAR (10)    NULL,
    [cd_siscomex]      INT          NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Agencia_Secex] PRIMARY KEY CLUSTERED ([cd_agencia_secex] ASC) WITH (FILLFACTOR = 90)
);

