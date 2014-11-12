CREATE TABLE [dbo].[Tributacao_Servico] (
    [cd_tributacao_servico] INT          NOT NULL,
    [nm_tributacao_servico] VARCHAR (60) NULL,
    [sg_tributacao_servico] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tributacao_Servico] PRIMARY KEY CLUSTERED ([cd_tributacao_servico] ASC)
);

