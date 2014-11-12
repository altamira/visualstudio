CREATE TABLE [dbo].[Manutencao_Saldo] (
    [cd_manutencao]             INT          NOT NULL,
    [dt_manutencao]             DATETIME     NULL,
    [cd_produto]                INT          NULL,
    [qt_produto_manutencao]     FLOAT (53)   NULL,
    [cd_tipo_movimento_estoque] INT          NULL,
    [ic_transferido]            CHAR (1)     NULL,
    [cd_usuario_manutencao]     INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [nm_obs_manutencao]         VARCHAR (40) NULL,
    CONSTRAINT [PK_Manutencao_Saldo] PRIMARY KEY CLUSTERED ([cd_manutencao] ASC) WITH (FILLFACTOR = 90)
);

