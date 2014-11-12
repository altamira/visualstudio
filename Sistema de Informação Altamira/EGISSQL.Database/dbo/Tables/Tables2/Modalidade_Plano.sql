CREATE TABLE [dbo].[Modalidade_Plano] (
    [cd_modalidade_plano]       INT          NOT NULL,
    [nm_modalidade_plano]       VARCHAR (30) NULL,
    [sg_modalidade_plano]       CHAR (10)    NULL,
    [ds_modalidade_plano]       TEXT         NULL,
    [ic_ativo_modalidade_plano] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Modalidade_Plano] PRIMARY KEY CLUSTERED ([cd_modalidade_plano] ASC) WITH (FILLFACTOR = 90)
);

