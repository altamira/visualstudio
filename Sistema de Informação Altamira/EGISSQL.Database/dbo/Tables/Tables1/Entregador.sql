CREATE TABLE [dbo].[Entregador] (
    [cd_entregador]          INT          NOT NULL,
    [nm_entregador]          VARCHAR (30) NOT NULL,
    [sg_entregador]          CHAR (10)    NOT NULL,
    [ic_custo_entrega]       CHAR (1)     NULL,
    [vl_custo_entrega]       FLOAT (53)   NULL,
    [ic_etiqueta_entregador] CHAR (1)     NOT NULL,
    [ic_minuta_entregador]   CHAR (1)     NOT NULL,
    [cd_placa_entregador]    CHAR (7)     NULL,
    [cd_transportadora]      INT          NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [ic_ativo_entregador]    CHAR (1)     NULL,
    [cd_veiculo]             INT          NULL,
    CONSTRAINT [PK_Entregador] PRIMARY KEY CLUSTERED ([cd_entregador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Entregador_Veiculo] FOREIGN KEY ([cd_veiculo]) REFERENCES [dbo].[Veiculo] ([cd_veiculo])
);

