CREATE TABLE [dbo].[Meio_Transporte_Historico] (
    [cd_historico]       INT          NOT NULL,
    [cd_meio_transporte] INT          NOT NULL,
    [dt_historico]       DATETIME     NULL,
    [vl_historico]       FLOAT (53)   NULL,
    [nm_obs_historico]   VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Meio_Transporte_Historico] PRIMARY KEY CLUSTERED ([cd_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meio_Transporte_Historico_Meio_Transporte] FOREIGN KEY ([cd_meio_transporte]) REFERENCES [dbo].[Meio_Transporte] ([cd_meio_transporte])
);

