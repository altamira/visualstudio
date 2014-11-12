CREATE TABLE [dbo].[SPED_Qualificacao_Assinante] (
    [cd_qualificacao]             INT           NOT NULL,
    [sg_qualificacao]             CHAR (10)     NULL,
    [nm_qualificacao]             VARCHAR (100) NULL,
    [nm_qualificacao_complemento] VARCHAR (100) NULL,
    [cd_usuario]                  INT           NULL,
    [dt_usuario]                  DATETIME      NULL,
    CONSTRAINT [PK_SPED_Qualificacao_Assinante] PRIMARY KEY CLUSTERED ([cd_qualificacao] ASC)
);

