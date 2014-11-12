CREATE TABLE [dbo].[Roteiro_Entrada_Pedido] (
    [cd_roteiro_entrada]  INT           NOT NULL,
    [dt_roteiro_entrada]  DATETIME      NULL,
    [cd_vendedor]         INT           NULL,
    [dt_download_roteiro] VARCHAR (20)  NULL,
    [dt_fim_roteiro]      VARCHAR (20)  NULL,
    [nm_obs_roteiro]      VARCHAR (40)  NULL,
    [nm_linha_roteiro]    VARCHAR (150) NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    CONSTRAINT [PK_Roteiro_Entrada_Pedido] PRIMARY KEY CLUSTERED ([cd_roteiro_entrada] ASC) WITH (FILLFACTOR = 90)
);

