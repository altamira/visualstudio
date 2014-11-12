CREATE TABLE [dbo].[Cidade_Feriado] (
    [cd_cidade]             INT          NOT NULL,
    [cd_feriado]            INT          NOT NULL,
    [dt_cidade_feriado]     DATETIME     NOT NULL,
    [nm_obs_cidade_feriado] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_estado]             INT          NOT NULL,
    [cd_pais]               INT          NOT NULL,
    CONSTRAINT [PK_Cidade_Feriado] PRIMARY KEY CLUSTERED ([cd_cidade] ASC, [cd_feriado] ASC, [cd_estado] ASC, [cd_pais] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cidade_Feriado_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

