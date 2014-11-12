CREATE TABLE [dbo].[Cliente_Substituicao_Tributari] (
    [cd_cliente]                INT          NOT NULL,
    [cd_categoria_produto]      INT          NOT NULL,
    [cd_cliente_subs_tributari] INT          NOT NULL,
    [cd_dispositivo_legal]      INT          NOT NULL,
    [nm_obs_cliente_subs_tribu] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Cliente_Substituicao_Tributari] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_categoria_produto] ASC, [cd_dispositivo_legal] ASC) WITH (FILLFACTOR = 90)
);

