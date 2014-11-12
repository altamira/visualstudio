CREATE TABLE [dbo].[Requisicao_Manutencao_Composicao] (
    [cd_requisicao_manutencao] INT          NOT NULL,
    [cd_item_req_manutencao]   INT          NOT NULL,
    [cd_equipamento]           INT          NULL,
    [nm_item_manutencao]       VARCHAR (40) NULL,
    [ds_item_manutencao]       TEXT         NULL,
    [dt_item_prev_manutencao]  DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Requisicao_Manutencao_Composicao] PRIMARY KEY CLUSTERED ([cd_requisicao_manutencao] ASC, [cd_item_req_manutencao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Manutencao_Composicao_Equipamento] FOREIGN KEY ([cd_equipamento]) REFERENCES [dbo].[Equipamento] ([cd_equipamento])
);

