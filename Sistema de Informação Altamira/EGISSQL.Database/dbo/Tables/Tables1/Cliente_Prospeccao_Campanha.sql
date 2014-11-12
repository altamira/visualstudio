CREATE TABLE [dbo].[Cliente_Prospeccao_Campanha] (
    [cd_cliente_prospeccao]     INT          NOT NULL,
    [cd_item_campanha_cliente]  INT          NOT NULL,
    [cd_campanha]               INT          NOT NULL,
    [ic_ativa_campanha]         CHAR (1)     NULL,
    [nm_obs_campanha]           VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_operador_telemarketing] INT          NULL,
    CONSTRAINT [PK_Cliente_Prospeccao_Campanha] PRIMARY KEY CLUSTERED ([cd_cliente_prospeccao] ASC, [cd_item_campanha_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Prospeccao_Campanha_Operador_Telemarketing] FOREIGN KEY ([cd_operador_telemarketing]) REFERENCES [dbo].[Operador_Telemarketing] ([cd_operador_telemarketing])
);

