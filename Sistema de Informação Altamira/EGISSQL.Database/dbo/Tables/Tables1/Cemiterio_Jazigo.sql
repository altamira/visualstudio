CREATE TABLE [dbo].[Cemiterio_Jazigo] (
    [cd_cemiterio]             INT       NOT NULL,
    [cd_cemiterio_quadra]      INT       NOT NULL,
    [cd_cemiterio_rua_alameda] INT       NOT NULL,
    [cd_cemiterio_jazigo]      INT       NOT NULL,
    [sg_cemiterio_jazigo]      CHAR (20) NOT NULL,
    [cd_tipo_contrato]         INT       NULL,
    [ds_cemiterio_jazigo]      TEXT      NULL,
    [cd_usuario]               INT       NULL,
    [dt_usuario]               DATETIME  NULL
);

