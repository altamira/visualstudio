CREATE TABLE [dbo].[Transporte] (
    [cd_transporte]          INT          NOT NULL,
    [nm_transporte]          VARCHAR (60) NULL,
    [nm_fantasia_transporte] VARCHAR (15) NULL,
    [sg_transporte]          CHAR (10)    NULL,
    [vl_transporte]          FLOAT (53)   NULL,
    [cd_tipo_despesa_comex]  INT          NULL,
    [nm_obs_transporte]      VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_moeda]               INT          NULL,
    CONSTRAINT [PK_Transporte] PRIMARY KEY CLUSTERED ([cd_transporte] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Transporte_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Transporte_Tipo_Despesa_Comex] FOREIGN KEY ([cd_tipo_despesa_comex]) REFERENCES [dbo].[Tipo_Despesa_Comex] ([cd_tipo_despesa_comex])
);

