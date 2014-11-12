CREATE TABLE [dbo].[Padrao_Cor] (
    [cd_padrao_cor]         INT           NOT NULL,
    [cd_cor]                INT           NULL,
    [nm_padrao_cor]         VARCHAR (100) NULL,
    [cd_localizacao_padrao] VARCHAR (30)  NULL,
    [cd_padrao]             VARCHAR (30)  NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_Padrao_Cor] PRIMARY KEY CLUSTERED ([cd_padrao_cor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Padrao_Cor_Cor] FOREIGN KEY ([cd_cor]) REFERENCES [dbo].[Cor] ([cd_cor])
);

