CREATE TABLE [dbo].[SPED_Config_Periodo] (
    [cd_periodo]           INT          NOT NULL,
    [nm_titulo_periodo]    VARCHAR (60) NULL,
    [dt_inicio_periodo]    DATETIME     NULL,
    [dt_fim_periodo]       DATETIME     NULL,
    [ic_ativo_periodo]     CHAR (1)     NULL,
    [ic_encerrado_periodo] CHAR (1)     NULL,
    [nm_obs_periodo]       VARCHAR (60) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_livro]             INT          NULL,
    CONSTRAINT [PK_SPED_Config_Periodo] PRIMARY KEY CLUSTERED ([cd_periodo] ASC),
    CONSTRAINT [FK_SPED_Config_Periodo_SPED_Livro] FOREIGN KEY ([cd_livro]) REFERENCES [dbo].[SPED_Livro] ([cd_livro])
);

