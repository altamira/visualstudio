CREATE TABLE [dbo].[Irregularidade_Fiscal] (
    [cd_irregularidade_fiscal] INT          NOT NULL,
    [nm_irregularidade_fiscal] VARCHAR (30) NULL,
    [sg_irregularidade_fiscal] CHAR (10)    NULL,
    [ic_carta_irregularidade]  CHAR (1)     NULL,
    [ic_lista_irregularidade]  CHAR (1)     NULL,
    [ds_irregularidade_fiscal] TEXT         NULL,
    [ds_observacao]            TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK__Irregularidade_F__5748DA5E] PRIMARY KEY CLUSTERED ([cd_irregularidade_fiscal] ASC) WITH (FILLFACTOR = 90)
);

