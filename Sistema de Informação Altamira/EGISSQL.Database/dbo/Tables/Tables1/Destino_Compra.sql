CREATE TABLE [dbo].[Destino_Compra] (
    [cd_destino_compra]     INT          NOT NULL,
    [nm_destino_compra]     VARCHAR (30) NULL,
    [sg_destino_compra]     CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_pad_destino_compra] CHAR (1)     NULL,
    CONSTRAINT [PK_Destino_Compra] PRIMARY KEY CLUSTERED ([cd_destino_compra] ASC) WITH (FILLFACTOR = 90)
);

