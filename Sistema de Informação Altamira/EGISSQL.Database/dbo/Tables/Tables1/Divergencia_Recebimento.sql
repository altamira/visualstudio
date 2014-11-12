CREATE TABLE [dbo].[Divergencia_Recebimento] (
    [cd_divergencia_receb]     INT          NOT NULL,
    [dt_divergencia_receb]     DATETIME     NULL,
    [cd_motivo_recebimento]    INT          NULL,
    [nm_obs_divergencia_receb] VARCHAR (40) NULL,
    [cd_fornecedor]            INT          NULL,
    [cd_nota_entrada]          INT          NULL,
    [cd_serie_nota_fiscal]     INT          NULL,
    [cd_tecnico]               INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Divergencia_Recebimento] PRIMARY KEY CLUSTERED ([cd_divergencia_receb] ASC) WITH (FILLFACTOR = 90)
);

