CREATE TABLE [dbo].[Transporte_Peso] (
    [cd_transporte_peso]         INT          NOT NULL,
    [cd_transporte]              INT          NOT NULL,
    [qt_peso_inicial_transporte] FLOAT (53)   NULL,
    [qt_peso_final_transporte]   FLOAT (53)   NULL,
    [vl_transporte_peso]         FLOAT (53)   NULL,
    [nm_obs_transporte_peso]     VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Transporte_Peso] PRIMARY KEY CLUSTERED ([cd_transporte_peso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Transporte_Peso_Transporte] FOREIGN KEY ([cd_transporte]) REFERENCES [dbo].[Transporte] ([cd_transporte])
);

