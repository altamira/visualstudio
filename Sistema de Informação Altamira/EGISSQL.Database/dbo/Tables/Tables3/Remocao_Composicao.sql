CREATE TABLE [dbo].[Remocao_Composicao] (
    [cd_remocao_composicao]  INT          NOT NULL,
    [cd_remocao]             INT          NULL,
    [cd_remocao_adicional]   INT          NULL,
    [ic_tipo_valor]          CHAR (1)     NULL,
    [vl_remocao_composicao]  FLOAT (53)   NULL,
    [nm_obs_despesa_remocao] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_base_valor]          CHAR (1)     NULL,
    CONSTRAINT [PK_Remocao_Composicao] PRIMARY KEY CLUSTERED ([cd_remocao_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Remocao_Composicao_Remocao_Adicional] FOREIGN KEY ([cd_remocao_adicional]) REFERENCES [dbo].[Remocao_Adicional] ([cd_remocao_adicional])
);

