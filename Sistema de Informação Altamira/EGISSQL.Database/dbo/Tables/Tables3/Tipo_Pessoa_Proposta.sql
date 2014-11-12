CREATE TABLE [dbo].[Tipo_Pessoa_Proposta] (
    [cd_tipo_pessoa_proposta] INT          NOT NULL,
    [nm_tipo_pessoa_proposta] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_pessoa_proposta] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [pk_cd_tipo_pessoa_proposta] PRIMARY KEY CLUSTERED ([cd_tipo_pessoa_proposta] ASC) WITH (FILLFACTOR = 90)
);

