CREATE TABLE [dbo].[Armazenagem_Composicao] (
    [cd_armazenagem_composicao]  INT          NOT NULL,
    [cd_armazenagem]             INT          NULL,
    [cd_armazenagem_adicional]   INT          NULL,
    [ic_tipo_valor]              CHAR (1)     NULL,
    [vl_armazenagem_composicao]  FLOAT (53)   NULL,
    [nm_obs_despesa_armazenagem] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_base_valor]              CHAR (1)     NULL,
    [vl_minimo_armazenagem]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Armazenagem_Composicao] PRIMARY KEY CLUSTERED ([cd_armazenagem_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Armazenagem_Composicao_Remocao_Adicional] FOREIGN KEY ([cd_armazenagem_adicional]) REFERENCES [dbo].[Remocao_Adicional] ([cd_remocao_adicional])
);

