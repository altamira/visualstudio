CREATE TABLE [dbo].[Bem_Patrimonio_Historico] (
    [cd_bem_historico]       INT          NOT NULL,
    [cd_bem]                 INT          NOT NULL,
    [dt_bem_historico]       DATETIME     NULL,
    [cd_patrimonio_anterior] VARCHAR (25) NULL,
    [cd_patrimonio_bem]      VARCHAR (25) NULL,
    [nm_motivo_historico]    VARCHAR (40) NULL,
    [nm_obs_historico]       VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Bem_Patrimonio_Historico] PRIMARY KEY CLUSTERED ([cd_bem_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Bem_Patrimonio_Historico_Bem] FOREIGN KEY ([cd_bem]) REFERENCES [dbo].[Bem] ([cd_bem])
);

