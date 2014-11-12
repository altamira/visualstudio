CREATE TABLE [dbo].[Cemiterio] (
    [cd_cemiterio]          INT          NOT NULL,
    [nm_cemiterio]          VARCHAR (60) NULL,
    [sg_cemiterio]          VARCHAR (10) NULL,
    [cd_cep]                VARCHAR (9)  NULL,
    [nm_endereco_cemiterio] VARCHAR (40) NULL,
    [nm_telefone_cemiterio] VARCHAR (30) NULL,
    [nm_fax_cemiterio]      VARCHAR (30) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Cemiterio] PRIMARY KEY CLUSTERED ([cd_cemiterio] ASC) WITH (FILLFACTOR = 90)
);

