CREATE TABLE [dbo].[Cliente_Suporte] (
    [cd_cliente]             INT          NOT NULL,
    [cd_cliente_suporte]     INT          NOT NULL,
    [cd_senha_supnet]        VARCHAR (15) NULL,
    [nm_obs_cliente_suporte] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_contato]             INT          NULL,
    CONSTRAINT [PK_Cliente_Suporte] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_cliente_suporte] ASC) WITH (FILLFACTOR = 90)
);

