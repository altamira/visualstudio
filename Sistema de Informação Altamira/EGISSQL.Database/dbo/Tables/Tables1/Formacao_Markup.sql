CREATE TABLE [dbo].[Formacao_Markup] (
    [cd_tipo_markup]          INT          NOT NULL,
    [cd_aplicacao_markup]     INT          NOT NULL,
    [pc_formacao_markup]      FLOAT (53)   NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [nm_obs_formacao_markup]  VARCHAR (40) NULL,
    [ic_tipo_formacao_markup] CHAR (1)     NULL,
    [cd_tipo_lucro]           INT          NULL,
    CONSTRAINT [PK_Formacao_markup] PRIMARY KEY CLUSTERED ([cd_tipo_markup] ASC, [cd_aplicacao_markup] ASC) WITH (FILLFACTOR = 90)
);

