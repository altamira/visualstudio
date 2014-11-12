CREATE TABLE [dbo].[Armazenagem] (
    [cd_armazenagem]          INT          NOT NULL,
    [nm_armazenagem]          VARCHAR (60) NULL,
    [nm_fantasia_armazenagem] VARCHAR (15) NULL,
    [sg_armazenagem]          CHAR (10)    NULL,
    [vl_armazenagem]          FLOAT (53)   NULL,
    [cd_tipo_despesa_comex]   INT          NULL,
    [nm_obs_armazenagem]      VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_moeda]                INT          NULL,
    CONSTRAINT [PK_Armazenagem] PRIMARY KEY CLUSTERED ([cd_armazenagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Armazenagem_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Armazenagem_Tipo_Despesa_Comex] FOREIGN KEY ([cd_tipo_despesa_comex]) REFERENCES [dbo].[Tipo_Despesa_Comex] ([cd_tipo_despesa_comex])
);

