CREATE TABLE [dbo].[Ajudante_Motorista] (
    [cd_ajudante]          INT          NOT NULL,
    [nm_ajudante]          VARCHAR (40) NULL,
    [nm_fantasia_ajudante] VARCHAR (15) NULL,
    [ic_ativo_ajudante]    CHAR (1)     NULL,
    [cd_fone_ajudante]     VARCHAR (15) NULL,
    [nm_obs_ajudante]      VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Ajudante_Motorista] PRIMARY KEY CLUSTERED ([cd_ajudante] ASC) WITH (FILLFACTOR = 90)
);

