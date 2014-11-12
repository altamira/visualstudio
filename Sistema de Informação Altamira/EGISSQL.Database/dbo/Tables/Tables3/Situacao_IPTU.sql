CREATE TABLE [dbo].[Situacao_IPTU] (
    [cd_situacao_iptu] INT          NOT NULL,
    [nm_situacao_iptu] VARCHAR (40) NULL,
    [sg_situacao_iptu] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Situacao_IPTU] PRIMARY KEY CLUSTERED ([cd_situacao_iptu] ASC) WITH (FILLFACTOR = 90)
);

