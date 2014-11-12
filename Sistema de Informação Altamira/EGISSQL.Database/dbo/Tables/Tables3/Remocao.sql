CREATE TABLE [dbo].[Remocao] (
    [cd_remocao]            INT          NOT NULL,
    [nm_remocao]            VARCHAR (60) NULL,
    [nm_fantasia_remocao]   VARCHAR (15) NULL,
    [sg_remocao]            CHAR (10)    NULL,
    [vl_remocao]            FLOAT (53)   NULL,
    [cd_tipo_despesa_comex] INT          NULL,
    [nm_obs_remocao]        VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_moeda]              INT          NULL,
    CONSTRAINT [PK_Remocao] PRIMARY KEY CLUSTERED ([cd_remocao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Remocao_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Remocao_Tipo_Despesa_Comex] FOREIGN KEY ([cd_tipo_despesa_comex]) REFERENCES [dbo].[Tipo_Despesa_Comex] ([cd_tipo_despesa_comex])
);

