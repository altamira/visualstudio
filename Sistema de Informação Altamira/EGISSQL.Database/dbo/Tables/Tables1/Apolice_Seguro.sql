CREATE TABLE [dbo].[Apolice_Seguro] (
    [cd_apolice_seguro]        INT          NOT NULL,
    [dt_apolice_seguro]        DATETIME     NULL,
    [vl_apolice_seguro]        FLOAT (53)   NULL,
    [nm_apolice_seguro]        VARCHAR (40) NULL,
    [cd_ident_apolice_seguro]  INT          NULL,
    [nm_obs_apolice_seguro]    VARCHAR (40) NULL,
    [dt_vencto_apolice_seguro] DATETIME     NULL,
    [dt_renova_apolice_seguro] DATETIME     NULL,
    [cd_seguradora]            INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Apolice_Seguro] PRIMARY KEY CLUSTERED ([cd_apolice_seguro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Apolice_Seguro_Seguradora] FOREIGN KEY ([cd_seguradora]) REFERENCES [dbo].[Seguradora] ([cd_seguradora])
);

