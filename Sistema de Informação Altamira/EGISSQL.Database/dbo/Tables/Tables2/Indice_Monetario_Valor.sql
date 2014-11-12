CREATE TABLE [dbo].[Indice_Monetario_Valor] (
    [cd_indice_monetario]     INT          NOT NULL,
    [dt_indice_monetario]     DATETIME     NOT NULL,
    [vl_indice_monetario]     FLOAT (53)   NOT NULL,
    [nm_obs_indice_monetario] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Indice_Monetario_Valor] PRIMARY KEY CLUSTERED ([cd_indice_monetario] ASC, [dt_indice_monetario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Indice_Monetario_Valor_Indice_Monetario] FOREIGN KEY ([cd_indice_monetario]) REFERENCES [dbo].[Indice_Monetario] ([cd_indice_monetario])
);

