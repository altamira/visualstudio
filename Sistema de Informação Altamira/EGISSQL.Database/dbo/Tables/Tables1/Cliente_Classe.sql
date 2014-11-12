CREATE TABLE [dbo].[Cliente_Classe] (
    [cd_classe_cliente]     INT          NOT NULL,
    [cd_cliente]            INT          NOT NULL,
    [cd_tipo_cliente]       INT          NOT NULL,
    [nm_obs_cliente_classe] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL
);

