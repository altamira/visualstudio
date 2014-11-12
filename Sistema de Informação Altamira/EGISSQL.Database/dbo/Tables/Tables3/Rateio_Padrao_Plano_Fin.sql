CREATE TABLE [dbo].[Rateio_Padrao_Plano_Fin] (
    [cd_rateio_padrao_plano_fin] INT          NOT NULL,
    [nm_rateio_padrao_plano_fin] VARCHAR (30) NULL,
    [sg_rateio_padrao_plano_fin] CHAR (15)    NULL,
    [ds_rateio_padrao_plano_fin] TEXT         NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Rateio_Padrao_Plano_Fin] PRIMARY KEY CLUSTERED ([cd_rateio_padrao_plano_fin] ASC) WITH (FILLFACTOR = 90)
);

