CREATE TABLE [dbo].[Agencia_Banco_Perfil] (
    [cd_agencia_banco]  INT      NOT NULL,
    [ds_perfil_agencia] TEXT     NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Agencia_Banco_Perfil] PRIMARY KEY CLUSTERED ([cd_agencia_banco] ASC) WITH (FILLFACTOR = 90)
);

