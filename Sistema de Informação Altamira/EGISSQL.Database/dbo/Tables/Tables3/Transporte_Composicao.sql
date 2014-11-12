CREATE TABLE [dbo].[Transporte_Composicao] (
    [cd_transporte_composicao]  INT          NOT NULL,
    [cd_transporte]             INT          NULL,
    [cd_transporte_adicional]   INT          NULL,
    [ic_tipo_valor]             CHAR (1)     NULL,
    [vl_transporte_composicao]  FLOAT (53)   NULL,
    [nm_obs_despesa_transporte] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_base_valor]             CHAR (1)     NULL,
    CONSTRAINT [PK_Transporte_Composicao] PRIMARY KEY CLUSTERED ([cd_transporte_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Transporte_Composicao_Remocao_Adicional] FOREIGN KEY ([cd_transporte_adicional]) REFERENCES [dbo].[Remocao_Adicional] ([cd_remocao_adicional])
);

