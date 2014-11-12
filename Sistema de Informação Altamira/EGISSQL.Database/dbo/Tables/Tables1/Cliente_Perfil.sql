CREATE TABLE [dbo].[Cliente_Perfil] (
    [cd_cliente]                INT      NOT NULL,
    [ds_perfil_cliente]         TEXT     NULL,
    [ds_perfil_entrega_cliente] TEXT     NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Cliente_Perfil] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90)
);

