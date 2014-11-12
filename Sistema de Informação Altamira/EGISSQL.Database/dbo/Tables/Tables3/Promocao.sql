CREATE TABLE [dbo].[Promocao] (
    [cd_promocao]          INT          NOT NULL,
    [nm_promocao]          VARCHAR (40) NULL,
    [dt_promocao]          DATETIME     NULL,
    [ds_promocao]          TEXT         NULL,
    [dt_inicio_promocao]   DATETIME     NULL,
    [dt_fim_promocao]      DATETIME     NULL,
    [cd_tipo_promocao]     INT          NULL,
    [cd_motivo_promocao]   INT          NULL,
    [cd_campanha]          INT          NULL,
    [ic_ativa_promocao]    CHAR (1)     NULL,
    [nm_obs_promocao]      VARCHAR (40) NULL,
    [pc_desconto_promocao] FLOAT (53)   NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Promocao] PRIMARY KEY CLUSTERED ([cd_promocao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Promocao_Campanha] FOREIGN KEY ([cd_campanha]) REFERENCES [dbo].[Campanha] ([cd_campanha])
);

