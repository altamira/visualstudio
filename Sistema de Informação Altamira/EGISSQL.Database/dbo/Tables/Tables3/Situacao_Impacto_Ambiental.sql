CREATE TABLE [dbo].[Situacao_Impacto_Ambiental] (
    [cd_situacao_impacto] INT          NOT NULL,
    [nm_situacao_impacto] VARCHAR (40) NULL,
    [sg_situacao_impacto] CHAR (10)    NULL,
    [ds_situacao_impacto] TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Situacao_Impacto_Ambiental] PRIMARY KEY CLUSTERED ([cd_situacao_impacto] ASC) WITH (FILLFACTOR = 90)
);

