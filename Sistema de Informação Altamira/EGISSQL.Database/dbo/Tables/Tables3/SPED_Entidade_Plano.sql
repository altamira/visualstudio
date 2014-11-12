CREATE TABLE [dbo].[SPED_Entidade_Plano] (
    [cd_entidade_plano] INT          NOT NULL,
    [nm_entidade_plano] VARCHAR (60) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [sg_entidade_plano] CHAR (10)    NULL,
    CONSTRAINT [PK_SPED_Entidade_Plano] PRIMARY KEY CLUSTERED ([cd_entidade_plano] ASC)
);

