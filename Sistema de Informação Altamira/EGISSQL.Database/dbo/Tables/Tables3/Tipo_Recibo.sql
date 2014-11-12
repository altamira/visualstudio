CREATE TABLE [dbo].[Tipo_Recibo] (
    [cd_tipo_recibo]        INT          NOT NULL,
    [nm_tipo_recibo]        VARCHAR (30) NULL,
    [sg_tipo_recibo]        CHAR (10)    NULL,
    [ds_tipo_recibo]        TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_padrao_tipo_recibo] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Recibo] PRIMARY KEY CLUSTERED ([cd_tipo_recibo] ASC) WITH (FILLFACTOR = 90)
);

