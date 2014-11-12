CREATE TABLE [dbo].[Projeto_Mercado] (
    [cd_projeto_mercado]          INT          NOT NULL,
    [nm_projeto_mercado]          VARCHAR (40) NULL,
    [sg_projeto_mercado]          CHAR (10)    NULL,
    [nm_fantasia_projeto_mercado] VARCHAR (15) NULL,
    [ic_ativo_projeto_mercado]    CHAR (1)     NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [cd_cliente]                  INT          NULL,
    CONSTRAINT [PK_Projeto_Mercado] PRIMARY KEY CLUSTERED ([cd_projeto_mercado] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Mercado_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

