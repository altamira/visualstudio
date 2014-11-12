CREATE TABLE [dbo].[Tipo_Diaria_Hotel_Indice] (
    [cd_indice_diaria]           INT          NOT NULL,
    [cd_tipo_diaria]             INT          NULL,
    [cd_moeda]                   INT          NULL,
    [dt_inicio_indice]           DATETIME     NULL,
    [dt_fim_indice]              DATETIME     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [vl_indice_moeda_diaria]     FLOAT (53)   NULL,
    [nm_obs_indice_moeda_diaria] VARCHAR (40) NULL,
    CONSTRAINT [PK_Tipo_Diaria_Hotel_Indice] PRIMARY KEY CLUSTERED ([cd_indice_diaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Diaria_Hotel_Indice_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

