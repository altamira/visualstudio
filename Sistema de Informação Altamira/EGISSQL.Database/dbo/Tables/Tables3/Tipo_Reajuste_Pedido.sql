CREATE TABLE [dbo].[Tipo_Reajuste_Pedido] (
    [cd_tipo_reajuste] INT          NOT NULL,
    [nm_tipo_reajuste] VARCHAR (50) NULL,
    [sg_tipo_reajuste] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Reajuste_Pedido] PRIMARY KEY CLUSTERED ([cd_tipo_reajuste] ASC) WITH (FILLFACTOR = 90)
);

