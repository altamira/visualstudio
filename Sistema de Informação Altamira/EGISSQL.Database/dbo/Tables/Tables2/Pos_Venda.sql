CREATE TABLE [dbo].[Pos_Venda] (
    [cd_pos_venda]          INT          NOT NULL,
    [dt_pos_venda]          DATETIME     NULL,
    [cd_vendedor]           INT          NULL,
    [cd_cliente_prospeccao] INT          NULL,
    [cd_status_pos_venda]   INT          NULL,
    [qt_retorno_pos_venda]  INT          NULL,
    [dt_retorno_pos_venda]  DATETIME     NULL,
    [nm_obs_pos_venda]      VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Pos_Venda] PRIMARY KEY CLUSTERED ([cd_pos_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pos_Venda_Cliente_Prospeccao] FOREIGN KEY ([cd_cliente_prospeccao]) REFERENCES [dbo].[Cliente_Prospeccao] ([cd_cliente_prospeccao])
);

