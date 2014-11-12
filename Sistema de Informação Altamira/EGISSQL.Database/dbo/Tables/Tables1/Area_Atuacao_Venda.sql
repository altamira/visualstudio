CREATE TABLE [dbo].[Area_Atuacao_Venda] (
    [cd_area_atuacao_venda] INT          NOT NULL,
    [nm_area_atuacao_venda] VARCHAR (40) NULL,
    [sg_area_atuacao_venda] CHAR (10)    NULL,
    [cd_cor]                INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Area_Atuacao_Venda] PRIMARY KEY CLUSTERED ([cd_area_atuacao_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Area_Atuacao_Venda_Cor] FOREIGN KEY ([cd_cor]) REFERENCES [dbo].[Cor] ([cd_cor])
);

