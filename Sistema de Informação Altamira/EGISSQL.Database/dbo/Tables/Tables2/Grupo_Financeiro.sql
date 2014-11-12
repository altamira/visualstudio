CREATE TABLE [dbo].[Grupo_Financeiro] (
    [cd_grupo_financeiro]      INT          NOT NULL,
    [nm_grupo_financeiro]      VARCHAR (40) NOT NULL,
    [sg_grupo_financeiro]      CHAR (10)    NOT NULL,
    [cd_mascara]               VARCHAR (20) NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [cd_grupo_conta]           INT          NULL,
    [cd_tipo_operacao]         INT          NULL,
    [ic_prev_grupo_financeiro] CHAR (1)     NULL,
    CONSTRAINT [PK_Grupo_Financeiro] PRIMARY KEY CLUSTERED ([cd_grupo_financeiro] ASC) WITH (FILLFACTOR = 90)
);

