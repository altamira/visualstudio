CREATE TABLE [dbo].[Plano_Academia_Modalidade] (
    [cd_plano]                INT          NOT NULL,
    [cd_modalidade]           INT          NOT NULL,
    [nm_obs_plano_modalidade] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Plano_Academia_Modalidade] PRIMARY KEY CLUSTERED ([cd_plano] ASC, [cd_modalidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Plano_Academia_Modalidade_Modalidade] FOREIGN KEY ([cd_modalidade]) REFERENCES [dbo].[Modalidade] ([cd_modalidade])
);

