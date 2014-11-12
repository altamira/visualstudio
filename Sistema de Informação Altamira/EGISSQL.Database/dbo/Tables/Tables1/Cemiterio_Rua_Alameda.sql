CREATE TABLE [dbo].[Cemiterio_Rua_Alameda] (
    [cd_cemiterio]             INT       NOT NULL,
    [cd_cemiterio_quadra]      INT       NOT NULL,
    [cd_cemiterio_rua_alameda] INT       NOT NULL,
    [sg_cemiterio_rua_alameda] CHAR (50) NOT NULL,
    [ds_cemiterio_rua_alameda] TEXT      NULL,
    [cd_usuario]               INT       NULL,
    [dt_usuario]               DATETIME  NULL
);

